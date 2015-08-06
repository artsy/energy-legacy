//
// ARPagingIDDownloaderOperation
// Created by orta on 3/26/14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.


#import "ARPagingDownloaderOperation.h"

SpecBegin(ARPagingIDDownloaderOperation);

__block NSString *address, *emptyAddress, *failingAddress;
__block NSArray *results, *emptyResults;
__block NSSet *resultsIDs;
__block BOOL completed = NO;

beforeEach(^{

    address = @"http://artsy.net/api/something";
    results = @[@{ @"id": @"blah", @"thing" : @"other" }, @{ @"id": @"bleh",  @"thing" : @"othar"}];
    resultsIDs = [NSSet setWithArray:@[@"blah", @"bleh"]];

    emptyAddress = @"http://artsy.net/api/empty";
    emptyResults = @[];

    failingAddress = @"http://artsy.net/api/fail";

    completed = NO;

    [OHHTTPStubs stubRequestsMatchingAddress:address returningJSONWithObject:results];
    [OHHTTPStubs stubRequestsMatchingAddress:emptyAddress returningJSONWithObject:emptyResults];
    [OHHTTPStubs stubRequestsMatchingAddress:failingAddress code:401];
});

pending(@"asks for a request", ^{

    ARPagingDownloaderOperation *operation = [[ARPagingDownloaderOperation alloc] init];
    operation.requestWithPage = ^NSURLRequest *(NSInteger i) {
        expect(i).to.equal(1);
        return [NSURLRequest requestWithURL:[NSURL URLWithString:emptyAddress]];
    };

    [operation start];
});

pending(@"completes when it fails", ^{
    waitUntil(^(DoneCallback done) {

        ARPagingDownloaderOperation *operation = [[ARPagingDownloaderOperation alloc] init];
        operation.requestWithPage = ^NSURLRequest *(NSInteger i) {
            return [NSURLRequest requestWithURL:[NSURL URLWithString:failingAddress]];
        };
        operation.failure = ^{
            done();
        };
        [operation start];
    });
});

pending(@"completes when getting zero results", ^{

    ARPagingDownloaderOperation *operation = [[ARPagingDownloaderOperation alloc] init];
    operation.requestWithPage = ^NSURLRequest *(NSInteger i) {
        return [NSURLRequest requestWithURL:[NSURL URLWithString:emptyAddress]];
    };

    operation.onCompletionWithIDs = ^(NSSet *set) {
        completed = YES;
    };

    [operation start];

    expect(completed).will.beTruthy();
    expect(operation.isFinished).will.beTruthy();
});

pending(@"makes multiple requests when it gets more than 0 objects", ^{

    __block BOOL giveEmptyResults = NO;
    __block NSInteger requestCount = 0;
    __block NSSet *downloadResults = nil;
    __block ARPagingDownloaderOperation *operation;

    beforeEach(^{
        operation = [[ARPagingDownloaderOperation alloc] init];
        operation.requestWithPage = ^NSURLRequest *(NSInteger i) {
            requestCount++;

            if(!giveEmptyResults){
                giveEmptyResults = YES;
                return [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
            }
            return [NSURLRequest requestWithURL:[NSURL URLWithString:emptyAddress]];
        };

        operation.onCompletionWithIDs = ^(NSSet *set) {
            downloadResults = set.copy;
        };

        [operation start];

    });

    it(@"expects to iterate twice", ^{
        expect(giveEmptyResults).will.beTruthy();
        expect(requestCount).will.equal(2);
    });

    it(@"should give the expected ids in the results", ^{
        expect(downloadResults).to.equal(resultsIDs);
    });

    it(@"completes correctly", ^{
        expect(operation.isFinished).will.beTruthy();
    });

});

pending(@"supports passing documents instead of just IDs", ^{
    ARPagingDownloaderOperation *operation = [[ARPagingDownloaderOperation alloc] init];
    operation.requestWithPage = ^NSURLRequest *(NSInteger i) {
        NSString *requestAddress = (i == 2) ? emptyAddress : address;
        return [NSURLRequest requestWithURL:[NSURL URLWithString:requestAddress]];
    };

    operation.onCompletionWithJSONDictionaries = ^(NSSet *set) {
        completed = YES;

        NSDictionary *jsonRep = set.anyObject;
        expect(jsonRep).to.beKindOf(NSDictionary.class);
        expect(jsonRep[@"thing"]).to.beTruthy();
    };

    [operation start];

    expect(completed).will.beTruthy();
    expect(operation.isFinished).will.beTruthy();
});

SpecEnd

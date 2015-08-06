//
// ARPagingIDDownloaderOperation
// Created by orta on 3/26/14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import <AFNetworking/AFJSONRequestOperation.h>
#import "ARPagingDownloaderOperation.h"


@interface ARPagingDownloaderOperation ()

@property (readonly, nonatomic, strong) NSMutableSet *slugs;
@property (readonly, nonatomic, strong) NSMutableSet *objects;

@property (readonly, nonatomic, assign) NSInteger index;
@end


@implementation ARPagingDownloaderOperation {
    BOOL _isFinished;
    BOOL _isExecuting;
}

- (void)start
{
    [self setFinished:NO];
    [self setExecuting:YES];

    _slugs = [NSMutableSet set];
    _objects = [NSMutableSet set];

    [self getNextPage];
}

- (void)getNextPage
{
    _index += 1;
    NSURLRequest *request = self.requestWithPage(self.index);
    [self pageWithRequest:request];
}

- (void)pageWithRequest:(NSURLRequest *)request
{
    AFHTTPRequestOperation *networkOperation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [networkOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject isKindOfClass:NSArray.class] && [responseObject count] != 0) {

            if (self.onCompletionWithIDs) {
                [self.slugs addObjectsFromArray:[responseObject map:^id(id object) {
                    return [object objectForKey:@"id"];
                }]];
            }

            if (self.onCompletionWithJSONDictionaries) {
                [self.objects addObjectsFromArray:responseObject];
            }

            [self getNextPage];

        } else {
            if (self.onCompletionWithIDs) {
                self.onCompletionWithIDs(self.slugs.copy);
            }

            if (self.onCompletionWithJSONDictionaries) {
                self.onCompletionWithJSONDictionaries(self.objects.copy);
            }

            [self setExecuting:NO];
            [self setFinished:YES];
        }

    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (self.slugs && self.onCompletionWithIDs) {
            self.onCompletionWithIDs(self.slugs.copy);

        } else if (self.objects && self.onCompletionWithJSONDictionaries) {
            self.onCompletionWithJSONDictionaries(self.objects.copy);

        } else if (self.failure) {
            self.failure();
        }

        [self setExecuting:NO];
        [self setFinished:YES];

        NSLog(@"completed paging but failed on %@, %@ - %@", operation.request.URL, NSStringFromClass(self.class), error.localizedDescription);
        }];

    [networkOperation start];
}

- (void)setFinished:(BOOL)isFinished
{
    if (isFinished != _isFinished) {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = isFinished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (BOOL)isFinished
{
    return _isFinished || [self isCancelled];
}

- (void)cancel
{
    [super cancel];
    if ([self isExecuting]) {
        [self setExecuting:NO];
        [self setFinished:YES];
    }
}

- (void)setExecuting:(BOOL)isExecuting
{
    if (isExecuting != _isExecuting) {
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = isExecuting;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

@end

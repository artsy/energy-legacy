//
// ArtistModelTests
// Created by orta on 14/01/2014.
//
//  Copyright (c) 2012 http://art.sy. All rights reserved.

#import "NSManagedObject+ActiveRecord.h"
#import "ARDefaults.h"

SpecBegin(Artist);

describe(@"collection methods", ^{
    NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];

    Artist *artist1 = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
    artist1.orderingKey = @"a";

    Artist *artist2 = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
    artist2.orderingKey = @"c";

    Artist *artist3 = [Artist stubbedArtistWithPublishedArtworks:NO inContext:context];
    artist3.orderingKey = @"b";

    describe(@"all artists fetch requests", ^{
        __block ForgeriesUserDefaults *hideUnpublished;

        beforeEach(^{
            hideUnpublished = [[ForgeriesUserDefaults alloc] init];
            id userDefaults = [OCMockObject mockForClass:NSUserDefaults.class];
            [[[[userDefaults stub] classMethod] andReturn:hideUnpublished] standardUserDefaults];
        });

        it(@"hides artists with only unpublished works when hide is set", ^{
            hideUnpublished.defaults[ARHideUnpublishedWorks] = @(YES);

            NSFetchRequest *allArtistsRequest = [Artist allArtistsFetchRequestInContext:context];
            NSArray *allArtists = [context executeFetchRequest:allArtistsRequest error:nil];
            expect([allArtists containsObject:artist1]).to.beTruthy();
            expect([allArtists containsObject:artist3]).to.beFalsy();
        });

        it(@"shows artists with only unpublished works when hide is off", ^{
            hideUnpublished.defaults[ARHideUnpublishedWorks] = @(NO);

            NSFetchRequest *allArtistsRequest = [Artist allArtistsFetchRequestInContext:context];
            NSArray *allArtists = [context executeFetchRequest:allArtistsRequest error:nil];
            expect([allArtists containsObject:artist1]).to.beTruthy();
            expect([allArtists containsObject:artist3]).to.beTruthy();
        });

        it(@"orders artists by ordering key", ^{
            hideUnpublished.defaults[ARHideUnpublishedWorks] = @(NO);

            NSFetchRequest *allArtistsRequest = [Artist allArtistsFetchRequestInContext:context];
            NSArray *allArtists = [context executeFetchRequest:allArtistsRequest error:nil];
            expect([allArtists[0] isEqual:artist1]).to.beTruthy();
            expect([allArtists[1] isEqual:artist3]).to.beTruthy();
            expect([allArtists[2] isEqual:artist2]).to.beTruthy();
        });

    });

});

SpecEnd

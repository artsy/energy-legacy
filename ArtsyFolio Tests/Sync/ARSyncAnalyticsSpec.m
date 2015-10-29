#import "ARSyncAnalytics.h"
#import <ARAnalytics/ARAnalytics.h>
#import "ARStubbedAnalytics.h"
#import "ARDefaults.h"

@interface ARSync (private)
@property (readwrite, nonatomic, strong) NSUserDefaults *defaults;
@property (readwrite, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end


SpecBegin(ARSyncAnalytics)

__block ARSync *sync;
__block ARSyncAnalytics *sut;
__block ARStubbedProvider *analytics;

beforeEach(^{
    sut = [[ARSyncAnalytics alloc] init];
    analytics = [ARStubbedProvider setupAnalyticsWithStubbedProvider];

    sync = [[ARSync alloc] init];
    sync.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
    sync.defaults = (id)[ForgeriesUserDefaults defaults:@{}];
});

describe(@"at the start", ^{
    it(@"sets ARSyncing in progress", ^{
        expect([sync.defaults boolForKey:ARSyncingIsInProgress]).to.equal(NO);

        [sut syncDidStart:sync];
        expect([sync.defaults boolForKey:ARSyncingIsInProgress]).to.equal(YES);
    });

    it(@"creates an analytics event", ^{
        expect(analytics.lastEventName).to.equal(nil);

        [sut syncDidStart:sync];
        expect(analytics.lastEventName).to.equal(@"sync_started");
    });
});


describe(@"at the end", ^{
    it(@"sets ARSyncing in progress as false", ^{
        [sync.defaults setBool:YES forKey:ARSyncingIsInProgress];

        [sut syncDidFinish:sync];
        expect([sync.defaults boolForKey:ARSyncingIsInProgress]).to.equal(NO);

    });

    it(@"creates an analytics event", ^{
        expect(analytics.lastEventName).to.equal(nil);

        [sut syncDidFinish:sync];
        expect(analytics.lastEventName).to.equal(@"sync_finished");
    });
});


SpecEnd

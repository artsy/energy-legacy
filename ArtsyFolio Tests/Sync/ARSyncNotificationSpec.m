#import "ARSyncNotification.h"
#import "ARSync+TestsExtension.h"

SpecBegin(ARSyncNotification);

__block ARSyncNotification *sut;

beforeEach(^{
    sut = [[ARSyncNotification alloc] init];
});

it(@"sends sync started at the start", ^{
    expect(^{
        [sut syncDidStart:nil];
    }).to.notify(ARSyncStartedNotification);
});

it(@"sends sync done at the start", ^{
    expect(^{
        [sut syncDidFinish:nil];
    }).to.notify(ARSyncFinishedNotification);
});

it(@"gets created on a sync", ^{
    ARSync *sync = [ARSync syncForTesting];
    expect([sync createsPluginInstanceOfClass:ARSyncNotification.class]).to.beTruthy();
});

SpecEnd

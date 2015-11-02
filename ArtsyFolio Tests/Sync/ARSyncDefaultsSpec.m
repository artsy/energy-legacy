#import "ARSyncDefaults.h"
#import "ARDefaults.h"
#import "ARSync+TestsExtension.h"

SpecBegin(ARSyncDefaults);

__block ARSyncDefaults *sut;
__block ARSync *sync;

beforeEach(^{
    sut = [[ARSyncDefaults alloc] init];
    sync = [ARSync syncForTesting];
});

it(@"sets finished first sync", ^{
    [sut syncDidFinish:sync];
    expect([sync.config.defaults boolForKey:ARFinishedFirstSync]).to.beTruthy();
});

it(@"turns off recommend sync", ^{
    [sync.config.defaults setBool:YES forKey:ARRecommendSync];

    [sut syncDidFinish:sync];
    expect([sync.config.defaults boolForKey:ARRecommendSync]).to.beFalsy();
});

it(@"sets the app sync version", ^{
    expect([sync.config.defaults objectForKey:ARAppSyncVersion]).to.beFalsy();

    [sut syncDidFinish:sync];
    expect([sync.config.defaults objectForKey:ARAppSyncVersion]).to.beTruthy();
});

it(@"sets the last sync date", ^{
    expect([sync.config.defaults objectForKey:ARLastSyncDate]).to.beFalsy();

    [sut syncDidFinish:sync];
    expect([sync.config.defaults objectForKey:ARLastSyncDate]).to.beTruthy();
});

it(@"gets created on a sync", ^{
    expect([sync createsPluginInstanceOfClass:ARSyncDefaults.class]).to.beTruthy();
});

SpecEnd

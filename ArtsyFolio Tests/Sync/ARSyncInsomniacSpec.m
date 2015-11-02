#import "ARSyncInsomniac.h"
#import "ARSync+TestsExtension.h"


@interface ARUIAppFake : NSObject
@property (nonatomic, getter=isIdleTimerDisabled) BOOL idleTimerDisabled;
@end


@implementation ARUIAppFake
@end


@interface ARSyncInsomniac ()
@property (readwrite, nonatomic, strong) UIApplication *sharedApplication;
@end


SpecBegin(ARSyncInsomniac);

__block ARSyncInsomniac *sut;
__block ARSync *sync;

beforeEach(^{
    sut = [[ARSyncInsomniac alloc] init];
    sut.sharedApplication = (id)[[ARUIAppFake alloc] init];
    sync = [ARSync syncForTesting];
});

it(@"tells a UIApp to not sleep when it starts", ^{
    expect(sut.sharedApplication.isIdleTimerDisabled).to.beFalsy();

    [sut syncDidStart:sync];
    expect(sut.sharedApplication.isIdleTimerDisabled).to.beTruthy();
});

it(@"tells a UIApp to sleep when its over", ^{
    sut.sharedApplication.idleTimerDisabled = YES;

    [sut syncDidFinish:sync];
    expect(sut.sharedApplication.isIdleTimerDisabled).to.beFalsy();
});

it(@"gets created on a sync", ^{
    expect([sync createsPluginInstanceOfClass:ARSyncInsomniac.class]).to.beTruthy();
});


SpecEnd

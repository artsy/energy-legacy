#import "ARSyncBackgroundedCheck.h"
#import "ARSync+TestsExtension.h"
#import <AFNetworking/AFNetworking.h>

SpecBegin(ARSyncBackgroundedCheck);

__block ARSyncBackgroundedCheck *sut;
__block ARSync *sync;

beforeEach(^{
    sut = [[ARSyncBackgroundedCheck alloc] init];
    sync = [ARSync syncForTesting];
});

it(@"listens for app will resign active and says it's backgrounded", ^{
    [sut syncDidStart:sync];
    expect(sut.applicationHasGoneIntoTheBackground).to.beFalsy();

    [[NSNotificationCenter defaultCenter] postNotificationName:ARApplicationDidGoIntoBackground object:nil];
    expect(sut.applicationHasGoneIntoTheBackground).to.beTruthy();
});

it(@"listens for reachability failing and says it's backgrounded", ^{
    [sut syncDidStart:sync];
    expect(sut.applicationHasGoneIntoTheBackground).to.beFalsy();

    NSNotification *notification = [NSNotification notificationWithName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:@{
        AFNetworkingReachabilityNotificationStatusItem : @(AFNetworkReachabilityStatusNotReachable)
    }];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
    expect(sut.applicationHasGoneIntoTheBackground).to.beTruthy();
});

it(@"listens for reachability failing and doesnt change if it's OK", ^{
    [sut syncDidStart:sync];
    expect(sut.applicationHasGoneIntoTheBackground).to.beFalsy();

    NSNotification *notification = [NSNotification notificationWithName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:@{
        AFNetworkingReachabilityNotificationStatusItem : @(AFNetworkReachabilityStatusReachableViaWiFi)
    }];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
    expect(sut.applicationHasGoneIntoTheBackground).to.beFalsy();
});

it(@"listens for reachability being OK doesn't change if it's backgrounded", ^{
    [sut syncDidStart:sync];
    expect(sut.applicationHasGoneIntoTheBackground).to.beFalsy();

    [[NSNotificationCenter defaultCenter] postNotificationName:ARApplicationDidGoIntoBackground object:nil];
    expect(sut.applicationHasGoneIntoTheBackground).to.beTruthy();

    NSNotification *notification = [NSNotification notificationWithName:AFNetworkingReachabilityDidChangeNotification object:nil userInfo:@{
        AFNetworkingReachabilityNotificationStatusItem : @(AFNetworkReachabilityStatusReachableViaWiFi)
    }];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
    expect(sut.applicationHasGoneIntoTheBackground).to.beTruthy();
});

it(@"gets created on a sync", ^{
    expect([sync createsPluginInstanceOfClass:ARSyncBackgroundedCheck.class]).to.beTruthy();
});

SpecEnd

#import "ARSyncBackgroundedCheck.h"
#import <AFNetworking/AFNetworking.h>


@interface ARSyncBackgroundedCheck ()
@property (readwrite, nonatomic, getter=applicationHasBackgrounded) BOOL applicationHasGoneIntoTheBackground;
@end


@implementation ARSyncBackgroundedCheck

- (void)syncDidStart:(ARSync *)sync
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:self selector:@selector(applicationWillResignActive:) name:ARApplicationDidGoIntoBackground object:nil];

    [notificationCenter addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)dealloc
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)syncDidFinish:(ARSync *)sync
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:ARApplicationDidGoIntoBackground object:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    self.applicationHasGoneIntoTheBackground = YES;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;

    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)[userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    self.applicationHasGoneIntoTheBackground = self.applicationHasGoneIntoTheBackground || status == AFNetworkReachabilityStatusNotReachable;
}

@end

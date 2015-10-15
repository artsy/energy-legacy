#import <AFNetworking/AFNetworking.h>

#import "ARSync.h"
#import "AROfflineStatusWatcher.h"


@interface AROfflineStatusWatcher ()
@property (nonatomic, strong, readonly) ARSync *sync;
@end


@implementation AROfflineStatusWatcher

- (instancetype)initWithSync:(ARSync *)sync
{
    self = [super init];
    if (!self) return nil;

    _sync = sync;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)[userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    [self.sync setPaused:status == AFNetworkReachabilityStatusNotReachable];
}

@end

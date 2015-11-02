#import "ARSyncInsomniac.h"


@interface ARSyncInsomniac ()

@property (readwrite, nonatomic, strong) UIApplication *sharedApplication;

@end


@implementation ARSyncInsomniac

- (void)syncDidStart:(ARSync *)sync
{
    self.sharedApplication.idleTimerDisabled = YES;
}

- (void)syncDidFinish:(ARSync *)sync
{
    self.sharedApplication.idleTimerDisabled = NO;
}

- (UIApplication *)sharedApplication
{
    return _sharedApplication ?: [UIApplication sharedApplication];
}

@end

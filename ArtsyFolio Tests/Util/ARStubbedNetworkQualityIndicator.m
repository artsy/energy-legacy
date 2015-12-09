#import "ARStubbedNetworkQualityIndicator.h"


@interface ARNetworkQualityIndicator ()
@property (nonatomic, copy) void (^pingBlock)(ARNetworkQuality quality);
@end


@implementation ARStubbedNetworkQualityIndicator

- (void)pingArtsy:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;
{
    completion(self.artsyIsUp, 1);
}

- (void)pingApple:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;
{
    completion(self.appleIsUp, 1);
}

- (void)beginObservingNetworkQuality:(void (^)(ARNetworkQuality quality))intervalPing
{
    _isListening = YES;
}

- (void)stopObservingNetworkQuality;
{
    _isListening = NO;
}

- (void)sendCallbackWithQuality:(ARNetworkQuality)quality
{
    self.pingBlock(quality);
}

@end

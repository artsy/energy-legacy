#import "ARNetworkQualityIndicator.h"


@interface ARStubbedNetworkQualityIndicator : ARNetworkQualityIndicator

@property (nonatomic, readonly) BOOL isListening;
@property (nonatomic, assign) BOOL appleIsUp;
@property (nonatomic, assign) BOOL artsyIsUp;

- (void)sendCallbackWithQuality:(ARNetworkQuality)quality;

@end

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ARNetworkQuality) {
    ARNetworkQualityOffline,
    ARNetworkQualitySlow,
    ARNetworkQualityOK,
    ARNetworkQualityGood
};

/// A class that makes it easy to ping either artsy or apple
/// optionally can be set to run on a loop checking every 3 seconds
/// what the network quality feels like.


@interface ARNetworkQualityIndicator : NSObject

/// Is Artsy up?
- (void)pingArtsy:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;

/// Is Apple up? A pretty reliable way to check if the user is offline
- (void)pingApple:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;

/// Start making networking calls every 3 seconds, calling the intervalPing block
/// with a quality estimate
- (void)beginObservingNetworkQuality:(void (^)(ARNetworkQuality quality))intervalPing;

/// Stop observing for network quality
- (void)stopObservingNetworkQuality;

@end

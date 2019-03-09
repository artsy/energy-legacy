#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface AREditAvailabilityNetworkModel : NSObject

/// Updates the main availability section of an artwork
- (void)updateArtwork:(Artwork *)artwork mainAvailability:(ARArtworkAvailability)availability completion:(void (^)(BOOL success))completion;

/// Updates the main availability section of an artwork
- (void)updateArtwork:(Artwork *)artwork editionSet:(EditionSet *)set toAvailability:(ARArtworkAvailability)availability completion:(void (^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END

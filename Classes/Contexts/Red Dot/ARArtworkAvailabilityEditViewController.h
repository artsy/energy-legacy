#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ARPopoverController;

/// This View Controller is essentially a facade between ARArtworkAvailabilityEditViewController
/// and AREditEditionsViewController depending on the Artwork's metadata.


@interface ARArtworkAvailabilityEditViewController : UIViewController

@property (readonly) Artwork *artwork;

- (instancetype)initWithArtwork:(Artwork *)artwork popover:(ARPopoverController *)popover;

@end

NS_ASSUME_NONNULL_END

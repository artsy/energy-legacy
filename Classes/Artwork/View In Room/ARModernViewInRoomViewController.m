#import <UIKit/UIKit.h>

/// Has two main states, a decorated version with parallax & the dude,
/// and a simple VIR. The simple VIR has a back button.

@class Artwork;


@interface ARModernViewInRoomViewController : UIViewController

+ (UIImageView *)imageViewForFramedArtwork;

/// Init with the artwork for the metadata
- (instancetype)initWithArtwork:(Artwork *)artwork;

@property (nonatomic, strong, readonly) Artwork *artwork;

@property (nonatomic, assign) BOOL popOnRotation;
@property (nonatomic, weak) UIViewController *rotationDelegate;

/// The artwork imageview comes *from* the transition
@property (nonatomic, strong) UIImageView *artworkImageView;

/// Returns the CGRect where the artwork will sit scaled
+ (CGRect)rectForImageViewWithArtwork:(Artwork *)artwork withContainerFrame:(CGRect)containerFrame;

/// Removes extra walls, benches etc
- (void)hideDecorationViews;

@end

#import "ARAmbiguousSplitStackView.h"

/// This is a split stack view that takes an artwork and generates its metadata.
/// This includes accessory metadata such as exhibition history and image rights.
/// It does not include things like titles or artist.


@interface ARArtworkInfoAdditionalMetadataView : ARAmbiguousSplitStackView

- (instancetype)initWithArtwork:(Artwork *)artwork preferredWidth:(CGFloat)preferredWidth split:(BOOL)split;

@end

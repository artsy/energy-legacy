

/// A horizontal strip of images that are selectable
/// which when selected show a purple tick in the bottom left


@interface ARThumbnailImageSelectionView : UIScrollView

/// Images to show in the strip
@property (readwrite, copy, nonatomic) NSArray<Image *> *images;

/// Optional border for the strip
@property (readwrite, strong, nonatomic) UIColor *borderColor;

/// Select a collection of images
- (void)selectImages:(NSArray<Image *> *)images;

/// Get out the selected indexes of the current images
- (NSIndexSet *)selectedIndexes;

/// Gotta catch them all.
- (void)selectAll;
@end

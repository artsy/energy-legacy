#import "ARGridViewItem.h"


@interface ARGridViewCell : UICollectionViewCell <UITextFieldDelegate, UIGestureRecognizerDelegate>

/// The image to show in the grid
@property (readwrite, strong, nonatomic) UIImage *image;
/// The first line of text
@property (readwrite, copy, nonatomic) NSString *title;
/// The 2nd line of text as a plain ole string
@property (readwrite, copy, nonatomic) NSString *subtitle;
/// The 2nd line of text as a fancy string
@property (readwrite, copy, nonatomic) NSAttributedString *attributedSubtitle;

/// The FS path for the local image
@property (readwrite, copy, nonatomic) NSString *imagePath;
/// The remote url for its image
@property (readonly, strong, nonatomic) NSURL *imageURL;

/// A locally caching grab this URL and show it API, used mostly by iPhone Folio
- (void)setImageURL:(NSURL *)imageURL savingLocallyAtPath:(NSString *)path;

/// What object is actually represented
@property (readwrite, weak, nonatomic) id<ARGridViewItem> item;

// For lookups from the datasource (and going backwards on selection etc)
@property (readwrite, strong, nonatomic) NSIndexPath *indexPath;

/// It looks weird to show metadata in italics when not on an artwork
@property (readwrite, assign, nonatomic) BOOL suppressItalics;
/// So that the image preview fits what the image will be as that's set async
@property (readwrite, assign, nonatomic) CGFloat aspectRatio;

/// Used during album item selection
- (void)setIsMultiSelectable:(BOOL)selectable animated:(BOOL)animated;
/// USed during album item selection
- (void)setVisuallySelected:(BOOL)selected animated:(BOOL)animated;

@end

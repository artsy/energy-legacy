#import "ARGridViewItem.h"


@interface ARGridViewCell : UICollectionViewCell <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (readwrite, strong, nonatomic) UIImage *image;
@property (readwrite, copy, nonatomic) NSString *title;
@property (readwrite, copy, nonatomic) NSString *subtitle;

@property (readwrite, strong, nonatomic) NSOperation *thumbnailOperation;

@property (readwrite, copy, nonatomic) NSString *imagePath;
@property (readonly, strong, nonatomic) NSURL *imageURL;
- (void)setImageURL:(NSURL *)imageURL savingLocallyAtPath:(NSString *)path;

@property (readwrite, weak, nonatomic) id<ARGridViewItem> item;

@property (readwrite, strong, nonatomic) NSIndexPath *indexPath;

@property (readwrite, assign, nonatomic) BOOL suppressItalics;
@property (readwrite, assign, nonatomic) CGFloat aspectRatio;

- (void)setIsMultiSelectable:(BOOL)selectable animated:(BOOL)animated;
- (void)setVisuallySelected:(BOOL)selected animated:(BOOL)animated;

@end

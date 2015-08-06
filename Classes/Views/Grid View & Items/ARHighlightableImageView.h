/// A view that contains the logic around the faux de-pressing
/// work for grid image previews


@interface ARHighlightableImageView : UIView

@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) UIColor *imageBackgroundColor;
@property (readwrite, nonatomic, assign) CGFloat aspectRatio;

@property (readonly, nonatomic, weak) UIImageView *imageView;

- (void)setContentInsetX:(CGFloat)insetX insetY:(CGFloat)insetY animated:(BOOL)animated;

- (void)addBadge:(UIImage *)image animated:(BOOL)animated;
- (void)removeBadgeAnimated:(BOOL)animated;

@end

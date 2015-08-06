typedef NS_ENUM(NSUInteger, ARImageBadgePosition) {
    TopLeft,
    TopRight,
    BottomLeft,
    BottomRight
};

@interface ARImageBadge : UIImageView

- (void)setPosition:(ARImageBadgePosition)position offset:(NSInteger)offset;

- (void)setSize:(CGFloat)height width:(CGFloat)width;

@end

@interface UIView (ARImageBadge)

@property (nonatomic, readonly)ARImageBadge *badge;

- (void)addBadgeWithImage:(UIImage *)image position:(ARImageBadgePosition)position offset:(CGFloat)offset;

- (void)addBadgeWithImage:(UIImage *)image position:(ARImageBadgePosition)position;

@end

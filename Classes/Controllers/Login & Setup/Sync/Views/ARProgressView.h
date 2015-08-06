

@interface ARProgressView : UIView

@property (nonatomic, assign, readwrite) CGFloat progress;
@property (nonatomic, assign, readwrite) CGFloat radius;

@property (nonatomic, strong, readwrite) UIColor *innerColor;
@property (nonatomic, strong, readwrite) UIColor *outerColor;
@property (nonatomic, strong, readwrite) UIColor *emptyColor;

@end

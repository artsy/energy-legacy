#import "ARDebugPlaceholderView.h"


@interface ARDebugPlaceholderView ()
@property (nonatomic, assign, readonly) CGSize size;
@end


@implementation ARDebugPlaceholderView

- (instancetype)initWithSize:(CGSize)size color:(UIColor *)color
{
    self = [super initWithFrame:(CGRect){CGPointZero, size}];
    if (!self) return nil;

    _size = size;
    self.backgroundColor = color;
    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];

    return self;
}

- (CGSize)intrinsicContentSize
{
    return self.size;
}

@end

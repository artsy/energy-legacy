

#import "ARNavigationBar.h"


@implementation ARNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self removeNavigationBarShadow];
    [self tintColorDidChange];

    return self;
}

- (void)removeNavigationBarShadow
{
    // Removes a single line from the nav bar.

    for (UIView *view in self.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UIImageView class]] && view2.frame.size.height < 2) {
                [view2 removeFromSuperview];
            }
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size.height = self.extendedHeight ? ARToolbarSizeHeight : ARToolbarSizeHeightPhone;
    size.width = self.superview.bounds.size.width;
    return size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.topItem) {
        [self verticallyCenterView:self.topItem.titleView];
        [self verticallyCenterView:self.topItem.leftBarButtonItems];
        [self verticallyCenterView:self.topItem.rightBarButtonItems];
    }
}

- (void)verticallyCenterView:(id)viewOrArray
{
    if ([viewOrArray isKindOfClass:[UIView class]]) {
        [self center:viewOrArray];

    } else {
        for (UIBarButtonItem *button in viewOrArray) {
            [self center:button.customView];
        }
    }
}

- (void)center:(UIView *)viewToCenter
{
    CGFloat barMidpoint = roundf(self.frame.size.height / 2);
    CGFloat viewMidpoint = roundf(viewToCenter.frame.size.height / 2);

    CGRect newFrame = viewToCenter.frame;
    newFrame.origin.y = roundf(barMidpoint - viewMidpoint);
    viewToCenter.frame = newFrame;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];

    // This fixes the custom back button background not showing
    // http://stackoverflow.com/questions/18824887/ios-7-custom-back-button/19452709#19452709
    [view setNeedsDisplay];
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];

    self.translucent = NO;
    self.barTintColor = [[self.class appearance] barTintColor];

    [self setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor artsyForegroundColor],
        NSFontAttributeName : [UIFont sansSerifFontWithSize:20]
    }];

    [self.topItem.titleView tintColorDidChange];

    for (UIBarButtonItem *item in self.topItem.rightBarButtonItems) {
        [item setTintColor:self.window.tintColor];
        [item.representedButton tintColorDidChange];
    }

    for (UIBarButtonItem *item in self.topItem.leftBarButtonItems) {
        [item setTintColor:self.window.tintColor];
        [item.representedButton tintColorDidChange];
    }

    UIView *background = [self.subviews firstObject];
    background.backgroundColor = background.backgroundColor;
}


@end

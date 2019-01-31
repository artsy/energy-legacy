

#import "ARNavigationBar.h"


@implementation ARNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self tintColorDidChange];

    return self;
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
    self.backgroundColor = [UIColor artsyBackgroundColor];
}


@end


#import <FLKAutoLayout/UIView+FLKAutoLayout.h>
#import "ARNavigationBar.h"


@implementation ARNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self removeNavigationBarShadow];
    [self tintColorDidChange];

    _extendedHeight = [UIDevice isPad];
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

//- (void)updateConstraints
//{
//    for (NSLayoutConstraint *constraint in self.constraints) {
//        if (constraint.constant == 44) {
//            constraint.constant =  200;//self.extendedHeight ? ARToolbarSizeHeight : ARToolbarSizeHeightPhone;
////            [self removeConstraint:constraint];
////            [self constrainHeight:@"72@1000"];
//        }
//    }
//    [super updateConstraints];
//}
//
//- (CGSize)sizeThatFits:(CGSize)size
//{
//    // TODO: Check for iOS 11
//
//    size.height = self.extendedHeight ? ARToolbarSizeHeight : ARToolbarSizeHeightPhone;
//    size.width = self.superview.bounds.size.width;
//    return size;
//}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFit = [super sizeThatFits:size];
//    if ([UIApplication sharedApplication].isStatusBarHidden) {
        if (sizeThatFit.height < 84.f) {
            sizeThatFit.height = 120.f;
        }
//    }
    return sizeThatFit;
}

- (void)setFrame:(CGRect)frame {
//    if ([UIApplication sharedApplication].isStatusBarHidden) {
        frame.size.height = 80;
//    }
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) containsString:@"BarBackground"]) {
            CGRect subViewFrame = subview.frame;
            subViewFrame.origin.y = 0;
            subViewFrame.size.height = self.extendedHeight ? ARToolbarSizeHeight : ARToolbarSizeHeightPhone;
            [subview setFrame: subViewFrame];
        }
        if ([NSStringFromClass([subview class]) containsString:@"BarContentView"]) {
            CGRect subViewFrame = subview.frame;
            subViewFrame.origin.y = 0;
            subViewFrame.size.height = self.extendedHeight ? ARToolbarSizeHeight : ARToolbarSizeHeightPhone;
            [subview setFrame: subViewFrame];
        }
    }
        if (self.topItem) {
            [self verticallyCenterView:self.topItem.titleView];
            [self verticallyCenterView:self.topItem.leftBarButtonItems];
            [self verticallyCenterView:self.topItem.rightBarButtonItems];
        }
}
//
//- (void)setFrame:(CGRect)frame
//{
//    CGSize size = [self sizeThatFits:CGSizeZero];
//    [super setFrame: CGRectMake(0, 0, size.width, size.height)];
//}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    for (UIView *subview in self.subviews) {
//        if ([NSStringFromClass([subview class]) containsString:@"BarBackground"]) {
//            CGRect subViewFrame = subview.frame;
//            subViewFrame.origin.y = -20;
//            subViewFrame.size.height = CUSTOM_FIXED_HEIGHT+20;
//            [subview setFrame: subViewFrame];
//        }
//    }
//
//    if (self.topItem) {
//        [self verticallyCenterView:self.topItem.titleView];
//        [self verticallyCenterView:self.topItem.leftBarButtonItems];
//        [self verticallyCenterView:self.topItem.rightBarButtonItems];
//    }
//}

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
     CGFloat height = self.extendedHeight ? ARToolbarSizeHeight : ARToolbarSizeHeightPhone;
    CGFloat barMidpoint = roundf(height / 2);
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
    background.backgroundColor = [UIColor debugColourPurple]; //background.backgroundColor;
}


@end

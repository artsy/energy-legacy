#import "ARNavigationBarOS11.h"

@implementation ARNavigationBarOS11

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width , ARToolbarSizeHeight);
}

- (void)layoutSubviews
{
    CGRect newFrame =CGRectMake(self.frame.origin.x, 0, self.frame.size.width, ARToolbarSizeHeight);
    //
    if(!CGRectEqualToRect(newFrame, self.frame)) {
        self.frame = newFrame;
    }
//     CGRectMake(self.frame.origin.x, 0, self.frame.size.width, ARToolbarSizeHeight);
//    setTitleVerticalPositionAdjustment(-10, for: UIBarMetrics.default)

//    for subview in self.subviews {
//        var stringFromClass = NSStringFromClass(subview.classForCoder)
//        if stringFromClass.contains("BarBackground") {
//            subview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: customHeight)
//            subview.backgroundColor = .yellow
//
//        }
//
//        stringFromClass = NSStringFromClass(subview.classForCoder)
//        if stringFromClass.contains("BarContent") {
//
//            subview.frame = CGRect(x: subview.frame.origin.x, y: 20, width: subview.frame.width, height: customHeight - 20)
//
//
//        }
//    }
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

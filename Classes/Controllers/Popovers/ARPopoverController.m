#import "ARPopoverController.h"


@implementation ARPopoverController

- (instancetype)initWithContentViewController:(UIViewController *)viewController
{
    self = [super initWithContentViewController:viewController];

    WYPopoverTheme *theme = [WYPopoverTheme themeForIOS7];

    theme.fillBottomColor = [UIColor whiteColor];
    theme.fillBottomColor = [UIColor whiteColor];
    theme.outerCornerRadius = 0;
    theme.viewContentInsets = UIEdgeInsetsZero;
    theme.arrowBase = 32;
    theme.arrowHeight = 16;

    self.theme = theme;

    return self;
}

@end

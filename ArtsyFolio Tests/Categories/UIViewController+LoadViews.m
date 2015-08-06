#import "UIViewController+LoadViews.h"


@implementation UIViewController (LoadViews)

- (void)loadViewsProgrammatically
{
    [self beginAppearanceTransition:YES animated:NO];
    [self endAppearanceTransition];
}

@end

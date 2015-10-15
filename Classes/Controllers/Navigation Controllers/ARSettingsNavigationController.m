#import "ARSettingsNavigationController.h"
#import "ARPopoverController.h"

// See ARNavigationController for explanation
// this one differs as it is for the settings
// popover navigation as it's thematically different.


@implementation ARSettingsNavigationController

// This is a workaround removing all of the swizzing in WYPopoverController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *controller = [super popViewControllerAnimated:animated];

    [self.hostPopoverController setPopoverContentSize:self.topViewController.preferredContentSize];
    return controller;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.hostPopoverController setPopoverContentSize:viewController.preferredContentSize];
    [super pushViewController:viewController animated:animated];
}

@end

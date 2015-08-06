#import "ARSettingsNavigationController.h"
#import "ARPopoverController.h"

// See ARNavigationController for explanation
// this one differs as it is for the settings
// popover navigation as it's thematically different.


@implementation ARSettingsNavigationController

// This is a workaround for the lack of pop support in WYPopoverController
// as swizzling the popViewController method crashes the app, and so they've
// never supported it.

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *controller = [super popViewControllerAnimated:animated];

    [self.hostPopoverController setPopoverContentSize:self.topViewController.preferredContentSize];
    return controller;
}

@end

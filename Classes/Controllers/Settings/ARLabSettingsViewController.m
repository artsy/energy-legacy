#import "ARLabSettingsViewController.h"
#import "ARTopViewController.h"

@interface ARLabSettingsViewController ()

@end

@implementation ARLabSettingsViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.delegate = self;

    self.preferredDisplayMode = [UIDevice isPad] ? UISplitViewControllerDisplayModeAllVisible : UISplitViewControllerDisplayModeAutomatic;
}

#pragma mark - Properly Shutting Down

- (void)exitSettingsPanel
{
    @try { [[self valueForKey:@"_hiddenPopoverController"] dismissPopoverAnimated:YES]; }
    @catch (__unused NSException *exception) {}

    [[ARTopViewController sharedInstance] dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UISplitViewControllerDelegate

// Ensures the master view is shown by default on iPhone
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

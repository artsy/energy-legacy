#import "ARLabSettingsSplitViewController.h"
#import "ARTopViewController.h"
#import "ARLabSettingsNavigationController.h"
#import "ARStoryboardIdentifiers.h"


@implementation ARLabSettingsSplitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.preferredDisplayMode = [UIDevice isPad] ? UISplitViewControllerDisplayModeAllVisible : UISplitViewControllerDisplayModeAutomatic;
    self.preferredPrimaryColumnWidthFraction = 0.4;
    self.delegate = self;

    self.navigationItem.leftBarButtonItem = [self.splitViewController displayModeButtonItem];

    [self showDetailViewControllerForSettingsSection:ARLabSettingsSectionSync];
}

- (void)showDetailViewControllerForSettingsSection:(ARLabSettingsSection)section
{
    UIViewController *detailViewController;

    switch (section) {
        case ARLabSettingsSectionSync:
            detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:SyncSettingsViewController];
            break;
        case ARLabSettingsSectionPresentationMode:
            detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:PresentationModeViewController];
            break;
        case ARLabSettingsSectionBackground:
            detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:BackgroundSettingsViewController];
            break;
        case ARLabSettingsSectionEmail:
            detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:EmailSettingsViewController];
            break;
    }

    ARLabSettingsNavigationController *nav = [self detailNavigationController];
    [nav pushViewController:detailViewController animated:YES];
    [self showDetailViewController:nav sender:self];
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
}

- (ARLabSettingsNavigationController *)detailNavigationController
{
    return [self.storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
}

- (ARLabSettingsNavigationController *)detailNavigationControllerWithRoot:(UIViewController *)rootVC
{
    return [[ARLabSettingsNavigationController alloc] initWithRootViewController:rootVC];
}

#pragma mark - exit strategy

- (void)exitSettingsPanel
{
    @try {
        [[self valueForKey:@"_hiddenPopoverController"] dismissPopoverAnimated:YES];
    }
    @catch (__unused NSException *exception) {
    }

    [[ARTopViewController sharedInstance] dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

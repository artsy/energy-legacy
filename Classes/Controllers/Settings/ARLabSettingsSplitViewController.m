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
}

- (void)showDetailViewControllerForSettingsSection:(ARLabSettingsSection)section
{
    ARLabSettingsNavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
    [self showDetailViewController:nav sender:self];

    switch (section) {
        case ARLabSettingsSectionSync:
            [nav performSegueWithIdentifier:ShowSyncSettingsViewController sender:nav];
            break;
        case ARLabSettingsSectionPresentationMode:
            [nav performSegueWithIdentifier:ShowPresentationModeSettingsViewController sender:nav];
        case ARLabSettingsSectionBackground:
            [nav performSegueWithIdentifier:ShowBackgroundSettingsViewController sender:nav];
        case ARLabSettingsSectionEmail:
            [nav performSegueWithIdentifier:ShowEmailSettingsViewController sender:nav];
        default:
            break;
    }
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
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

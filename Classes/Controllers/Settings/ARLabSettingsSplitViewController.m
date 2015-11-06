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
            [nav performSegueWithIdentifier:ShowEditPresentationModeViewController sender:nav];
        default:
            break;
    }
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

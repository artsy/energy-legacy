#import "ARSettingsSplitViewController.h"
#import "ARTopViewController.h"
#import "ARStoryboardIdentifiers.h"

#import "ARBaseViewController+TransparentModals.h"


@implementation ARSettingsSplitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.preferredDisplayMode = [UIDevice isPad] ? UISplitViewControllerDisplayModeAllVisible : UISplitViewControllerDisplayModeAllVisible;
    self.preferredPrimaryColumnWidthFraction = 0.4;
    self.delegate = self;

    /// This ensures the detail view background is clear on iPad
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    [self showDetailViewController:[self.storyboard instantiateViewControllerWithIdentifier:TransparentViewController] sender:self];
}

- (void)showDetailViewControllerForSettingsSection:(ARSettingsSection)section
{
    self.view.backgroundColor = [UIColor artsyLightGrey];
    self.view.opaque = YES;

    UIViewController *detailViewController;

    switch (section) {
        case ARSettingsSectionSync:
            detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:SyncSettingsViewController];
            break;
        case ARSettingsSectionEditPresentationMode:
            detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:PresentationModeViewController];
            break;
        case ARSettingsSectionBackground:
            detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:BackgroundSettingsViewController];
            break;
        case ARSettingsSectionEmail:
            detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:EmailSettingsViewController];
            break;
        default:
            break;
    }


    UINavigationController *detailNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
    [detailNavigationController pushViewController:detailViewController animated:YES];
    [self showDetailViewController:detailNavigationController sender:self];
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

@end

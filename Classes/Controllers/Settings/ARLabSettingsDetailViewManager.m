#import "ARLabSettingsDetailViewManager.h"
#import "ARSyncStatusViewModel.h"
#import "ARTopViewController.h"


@implementation ARLabSettingsDetailViewManager

- (id)viewModelForSection:(ARLabSettingsSection)section
{
    switch (section) {
        case ARLabSettingsSectionSync:
            return [[ARSyncStatusViewModel alloc] initWithSync:[ARTopViewController sharedInstance].sync];
            break;

        default:
            return nil;
            break;
    }
}

#pragma mark - UISplitViewControllerDelegate

// Ensures the master view is shown by default on iPhone
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
}

@end

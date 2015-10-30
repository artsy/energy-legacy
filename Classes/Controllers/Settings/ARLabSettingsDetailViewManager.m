#import "ARLabSettingsDetailViewManager.h"
#import "ARSyncStatusViewModel.h"
#import "ARTopViewController.h"


@interface ARLabSettingsDetailViewManager ()
@end


@implementation ARLabSettingsDetailViewManager

- (id)viewModelForSection:(ARLabSettingsSection)section
{
    switch (section) {
        case ARLabSettingsSectionSync:
            return [[ARSyncStatusViewModel alloc] initWithSync:[ARTopViewController sharedInstance].sync context:self.context];
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

#pragma mark - dependency injection

- (NSManagedObjectContext *)context
{
    return _context ?: [CoreDataManager mainManagedObjectContext];
}

@end

#import "ARLabSettingsNavigationController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARSyncStatusViewModel.h"
#import "ARLabSettingsSyncViewController.h"
#import "ARTopViewController.h"
#import "ARLabSettingsMasterViewController.h"


@interface ARLabSettingsNavigationController ()


@end


@implementation ARLabSettingsNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.topViewController isKindOfClass:ARLabSettingsSyncViewController.class]) {
        [(ARLabSettingsSyncViewController *)self.topViewController setViewModel:self.syncViewModel];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isDetailViewController = [viewController conformsToProtocol:@protocol(ARLabSettingsDetailViewController)];

    if (isDetailViewController) {
        UIViewController<ARLabSettingsDetailViewController> *vc = viewController;

        switch (vc.section) {
            case ARLabSettingsSectionSync:
                [(ARLabSettingsSyncViewController *)vc setViewModel:self.syncViewModel];
                break;
            default:
                break;
        }
    }

    [super pushViewController:viewController animated:animated];
}

- (ARSyncStatusViewModel *)syncViewModel
{
    return [[ARSyncStatusViewModel alloc] initWithSync:self.sync context:self.managedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

- (ARSync *)sync
{
    return _sync ?: [ARTopViewController sharedInstance].sync;
}

@end

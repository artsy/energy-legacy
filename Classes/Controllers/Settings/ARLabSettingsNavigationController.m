#import "ARLabSettingsNavigationController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARSyncStatusViewModel.h"
#import "ARLabSettingsSyncViewController.h"
#import "ARTopViewController.h"


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BOOL isDetailViewController = [segue.destinationViewController conformsToProtocol:@protocol(ARLabSettingsDetailViewController)];

    if (isDetailViewController) {
        UIViewController<ARLabSettingsDetailViewController> *vc = segue.destinationViewController;

        switch (vc.section) {
            case ARLabSettingsSectionSync:
                [(ARLabSettingsSyncViewController *)vc setViewModel:self.syncViewModel];
                break;
            default:
                break;
        }
    }
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

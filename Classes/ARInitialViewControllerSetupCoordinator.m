#import "ARInitialViewControllerSetupCoordinator.h"
#import "UIViewController+SimpleChildren.h"
#import "ARSafeAreaAwareViewController.h"
#import "ARFileUtils+FolioAdditions.h"
#import "ARNavigationController.h"
#import "ARTopViewController.h"
#import "ARLogoutManager.h"
#import "AROptions.h"
#import "ARMigrationController.h"
#import "ARFolioMessageViewController.h"
#import "ARZeroStateMessageViewController.h"
#import "ARBaseViewController+TransparentModals.h"


@interface ARInitialViewControllerSetupCoordinator ()
@property (nonatomic, readonly, strong) ARSync *sync;
@end


@implementation ARInitialViewControllerSetupCoordinator

- (instancetype)initWithWindow:(UIWindow *)window sync:(ARSync *)sync
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _window = window;
    _sync = sync;

    return self;
}

+ (void)presentBetaCoreDataError
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSString *message = @"The Folio Beta has to delete your current database to continue.\nPlease restart the app.";
    ARSyncMessageViewController *messageViewController = [[ARSyncMessageViewController alloc] initWithMessage:message sync:nil];
    [window setRootViewController:messageViewController];
    [window makeKeyAndVisible];

    NSURL *storeURL = [NSURL fileURLWithPath:[ARFileUtils coreDataStorePath]];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    if (error) {
        NSLog(@"Error deleting Core Data Store: %@", error);
    }
}

- (void)setupFolioGrid
{
    [self setupFolioGridWithContext:nil];
}

- (void)setupFolioGridWithContext:(NSManagedObjectContext *)context
{
    ARTopViewController *topViewController = [ARTopViewController sharedInstance];
    topViewController.sync = self.sync;
    topViewController.managedObjectContext = context;

    ARNavigationController *navigationController = [ARNavigationController rootController];
    navigationController.viewControllers = @[ topViewController ];

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
}

- (void)presentLoginScreen:(BOOL)animated
{
    ARLoginViewController *loginViewController = [[ARLoginViewController alloc] init];
    loginViewController.sync = self.sync;
    loginViewController.completionBlock = ^{
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            [self presentSyncScreen:YES];
        }];
    };

    [self wrapInNavigationAndPresent:loginViewController animated:animated];
}

- (void)presentSyncScreen:(BOOL)animated
{
    [self presentSyncScreen:animated startSync:YES context:[CoreDataManager mainManagedObjectContext]];
}

- (void)presentSyncScreen:(BOOL)animated startSync:(BOOL)shouldSync context:(NSManagedObjectContext *)context
{
    ARSyncViewController *syncViewController = [[ARSyncViewController alloc] init];

    syncViewController.managedObjectContext = context;
    [syncViewController setPartnerName:[Partner currentPartnerInContext:context].name];
    self.sync.delegate = syncViewController;
    self.sync.progress.delegate = syncViewController;

    if (shouldSync) {
        // expect this to block
        [ARMigrationController performMigrationsInContext:context];
        // expect this to not
        [self.sync sync];
    }

    syncViewController.completionBlock = ^{
        // if the sync finishes too quickly, the VC might dismiss before the sync VC is finished presenting
        ar_dispatch_after(0.5, ^{
            [self.window.rootViewController dismissViewControllerAnimated:animated completion:^{
                // now that we have a sync finished, check for limited access and existence of works
                if ([Partner currentPartner].partnerLimitedAccess.boolValue) {
                    [ARAnalytics event:ARLockoutEvent];
                    [self presentLockoutScreenContext:context];

                } else if (![Partner currentPartner].hasUploadedWorks) {
                    [ARAnalytics event:ARZeroStateEvent];
                    [self presentZeroStateScreen];
                }
            }];
        });
    };

    [self wrapInNavigationAndPresent:syncViewController animated:animated];
}

- (void)wrapInNavigationAndPresent:(UIViewController *)controller animated:(BOOL)animated
{
    ARSafeAreaAwareViewController *safeAreaController = [[ARSafeAreaAwareViewController alloc] init];
    [safeAreaController loadViewIfNeeded];

    ARNavigationController *navigationController = [[ARNavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBarHidden = YES;

    [safeAreaController ar_addModernChildViewController:navigationController intoView:safeAreaController.safeView];
    [navigationController.view alignToView:safeAreaController.safeView];

    [self.window.rootViewController presentViewController:safeAreaController animated:animated completion:nil];
}

- (void)presentLogoutScreen:(BOOL)animated
{
    [self presentLogoutScreen:animated logout:YES];
}

- (void)presentLogoutScreen:(BOOL)animated logout:(BOOL)logout
{
    ARLogoutViewController *logoutViewController = [[ARLogoutViewController alloc] init];
    logoutViewController.modalPresentationStyle = UIModalPresentationFullScreen;

    ARNavigationController *navigationController = [[ARNavigationController alloc] initWithRootViewController:logoutViewController];
    navigationController.navigationBarHidden = YES;

    [self.window.rootViewController presentViewController:navigationController animated:animated completion:^{
        if (logout) {
            [[ARLogoutManager sharedLogoutManager] run];
        }
    }];
}

#pragma mark -
#pragma mark Lockout

- (void)presentLockoutScreenContext:(NSManagedObjectContext *)context
{
    if (self.window.rootViewController.transparentModalViewController) {
        return;
    }

    CGFloat alpha = [AROptions boolForOption:AROptionsUseWhiteFolio] ? 0.8 : 0.65;

    Partner *partner = [Partner currentPartnerInContext:context];
    User *user = [User currentUserInContext:context];
    ARFolioMessageViewController *lockoutViewController = [[ARFolioMessageViewController alloc] init];

    if (partner.limitedFolioAccess) {
        // E.g. their subscription does not include Folio
        lockoutViewController.messageText = NSLocalizedString(@"You do not have access to Artsy Folio", @"Folio limited access title");
        lockoutViewController.callToActionText = NSLocalizedString(@"Interested in Folio access? Contact your dedicated liaison for support", @"Folio limited access subtitle");
        NSString *email = partner.admin.email ?: @"partnersupport@artsy.net";
        lockoutViewController.callToActionAddress = [NSString stringWithFormat:@"mailto:%@", email];
        lockoutViewController.buttonText = @"Contact Support";

    } else {
        // This is the case when a partner has expired from CMS access
        lockoutViewController.messageText = NSLocalizedString(@"We Hope You Enjoyed Your Free Trial of Folio", @"Folio lockout title");
        lockoutViewController.callToActionText = NSLocalizedString(@"To regain access to your Folio, apply for an Artsy Gallery Partnership", @"Folio lockout subtitle");
        NSString *urlFormat = @"https://www.artsy.net/gallery-partnerships?partner_id=%@&user_id=%@&utm_medium=mobile&utm_source=folio&utm_campaign=fair_access";
        lockoutViewController.callToActionAddress = [NSString stringWithFormat:urlFormat, partner.slug, user.slug];
        lockoutViewController.buttonText = @"Apply";
    }

    if ([user isAdmin]) {
        lockoutViewController.secondaryButtonText = @"ADMIN SKIP";
        lockoutViewController.secondaryAction = ^() {
            [self.window.rootViewController dismissTransparentModalViewControllerAnimated:YES];
        };
    }
    [self.window.rootViewController presentTransparentModalViewController:lockoutViewController animated:NO withAlpha:alpha];
}

#pragma mark -
#pragma mark Zero State

- (void)presentZeroStateScreen
{
    ARZeroStateMessageViewController *zeroStateViewController = [[ARZeroStateMessageViewController alloc] init];
    [self.window.rootViewController presentTransparentModalViewController:zeroStateViewController animated:NO withAlpha:1];
}

- (void)dismissCurrentModal
{
    [self.window.rootViewController dismissTransparentModalViewControllerAnimated:YES];
}


@end

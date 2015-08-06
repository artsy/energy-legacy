#import "ARLogoutViewController.h"
#import "ARSyncViewController.h"
#import "ARSyncMessageViewController.h"
#import "ARLoginViewController.h"

/// Sets up the view controller heirarchy
/// when the app is first launched


@interface ARInitialViewControllerSetupCoordinator : NSObject

- (instancetype)initWithWindow:(UIWindow *)window sync:(ARSync *)sync;

@property (nonatomic, readonly, strong) UIWindow *window;

/// Fires up a window + VC, saying there is a core data error
+ (void)presentBetaCoreDataError;

/// Creates the default grid of artworks via an ARTopViewController in an ARNavigationController
- (void)setupFolioGrid;

/// Create the default grid with a specific maanaged object context
- (void)setupFolioGridWithContext:(NSManagedObjectContext *)context;

/// Creates and presents a ARLoginViewController modally in an ARNavigationController
- (void)presentLoginScreen:(BOOL)animated;

/// Creates and presents a ARLogoutViewController modally, and logs out
- (void)presentLogoutScreen:(BOOL)animated;

/// Creates and presents a ARLogoutViewController modally and optionally logs out
- (void)presentLogoutScreen:(BOOL)animated logout:(BOOL)logout;

/// Creates and presents a ARSyncViewController modally in an ARNavigationController and starts the sync
- (void)presentSyncScreen:(BOOL)animated;

/// Same as above but with a custom managed object context and the ability to choose whether to trigger a sync or not
- (void)presentSyncScreen:(BOOL)animated startSync:(BOOL)shouldSync context:(NSManagedObjectContext *)context;

/// Creates and presents a transparent ARFolioMessageViewController with lockout copy
- (void)presentLockoutScreenContext:(NSManagedObjectContext *)context;

/// Creates and presents a FolioMessageView with link to CMS
- (void)presentZeroStateScreen;

@end

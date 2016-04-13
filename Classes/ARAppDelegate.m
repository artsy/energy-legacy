#import <HockeySDK-Source/HockeySDK.h>
#import <JLRoutes/JLRoutes.h>

#import "ARAppDelegate.h"
#import "ARUserManager.h"
#import "ARRouter.h"
#import "ARSwitchBoard.h"
#import "AROptions.h"

#import "AlbumUpload.h"

#import "ARSync.h"
#import "ARPartnerMetadataSync.h"
#import "ARAnalyticsHelper.h"
#import "ARInitialViewControllerSetupCoordinator.h"
#import "AROfflineStatusWatcher.h"

#import "ARLogoutManager.h"
#import "ARTheme.h"
#import "ARAppDelegate+DevTools.h"

void uncaughtExceptionHandler(NSException *exception);


@interface ARAppDelegate ()

@property (nonatomic, strong, readonly) ARSync *sync;
@property (nonatomic, strong, readonly) ARPartnerMetadataSync *partnerSync;
@property (nonatomic, strong, readonly) ARInitialViewControllerSetupCoordinator *viewCoordinator;
@property (nonatomic, strong, readonly) ARAnalyticsHelper *analyticsHelper;
@property (nonatomic, strong, readonly) AROfflineStatusWatcher *statusWatcher;
@property (nonatomic, strong, readonly) ARUserManager *userManager;

// Needed for testing.
@property (nonatomic, strong) id defaultsClassMock;
@end


@implementation ARAppDelegate

@synthesize window;

// These methods are not ran during unit tests. See main.m.

/// Sets up other objects and their contexts

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self checkForCommonDevIssues];

    // Add uncaught exception handler for analytics
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    @try {
        // Setups up the Core Data stack if we get
        // an exception raised then we delete the users db
        [Partner currentPartner];
    }

    @catch (NSException *exception) {
        [ARInitialViewControllerSetupCoordinator presentBetaCoreDataError];
        return YES;
    }

    [ARDefaults registerDefaults];
    [ARLogging setup];
    [ARRouter setup];

    _analyticsHelper = [[ARAnalyticsHelper alloc] init];
    [self.analyticsHelper setup];
}

/// Creates view heriarchy, and lazier-loaded objects

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // There is a presented view controller from willFinish above
    if (application.keyWindow) {
        return YES;
    }

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen.mainScreen bounds]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSManagedObjectContext *context = [CoreDataManager mainManagedObjectContext];

    _sync = [[ARSync alloc] init];
    self.sync.progress = [[ARSyncProgress alloc] init];
    self.sync.config = [[ARSyncConfig alloc] initWithManagedObjectContext:context defaults:defaults deleter:[[ARSyncDeleter alloc] init]];

    _partnerSync = [[ARPartnerMetadataSync alloc] init];
    _statusWatcher = [[AROfflineStatusWatcher alloc] initWithSync:self.sync];
    _viewCoordinator = [[ARInitialViewControllerSetupCoordinator alloc] initWithWindow:self.window sync:self.sync];
    _userManager = [[ARUserManager alloc] init];

    [self.viewCoordinator setupFolioGrid];

    BOOL useWhiteFolio = [defaults boolForKey:AROptionsUseWhiteFolio];
    BOOL hasLoggedInSyncedUser = self.userManager.userCredentialsExist && [Partner currentPartner];
    BOOL hasLoggedInUnsyncedUser = [defaults boolForKey:ARStartedFirstSync] && ![defaults boolForKey:ARFinishedFirstSync];
    BOOL loggedIn = self.userManager.userIsLoggedIn;
    BOOL lockedOut = NO;

    [ARTheme setupWithWhiteFolio:useWhiteFolio];


    if (ARIsOSSBuild) {
        // NO-OP
        // This means it opens like normal, but won't trigger a sync.
        ARAppLifecycleLog(@"Loading OSS version of Folio - we hope you enjoy looking around!");
        ARAppLifecycleLog(@"\n Send us questions to mobile@artsymail.com or write issues on artsy/energy.");

    } else if (hasLoggedInSyncedUser && !hasLoggedInUnsyncedUser) {
        if (!loggedIn) {
            // run like normal but update token in background
            [self updateExpiredAuthToken];
        }

        [ARAnalytics identifyUserWithID:[User currentUser].slug andEmailAddress:[User currentUser].email];

        /// Check to see if the partner was previously locked out and lock them out if so
        if (self.shouldLockout) {
            lockedOut = YES;
            [self lockout];
        }

        /// Update the metadata in case their status has changed since last sync, or they have no artworks
        [self updatePartnerMetadataCompletion:^{

            if (self.shouldLockout && !lockedOut) {
                /// If they've had access revoked since last sync and they aren't currently locked out, lockout
                [self lockout];

            } else if (lockedOut) {
                /// If their access was restored since last sync and they're currently locked out, remove the modal
                [self.viewCoordinator dismissCurrentModal];

            } else if (![Partner currentPartner].hasUploadedWorks) {
                /// If they have no uploaded works, present the zero state modal
                [ARAnalytics event:ARZeroStateEvent];
                [self.viewCoordinator presentZeroStateScreen];
            }
        }];

    } else if (hasLoggedInUnsyncedUser) {
        // If we quit in the middle of the first sync, go back to sync view. Lockout will occur after sync for ineligible partners.
        [self.viewCoordinator presentSyncScreen:YES];

    } else {
        // Show the login screen
        [self.viewCoordinator presentLoginScreen:NO];
    }

    [self performDeveloperExtras];

    Album *album = [Album createOrFindAlbumInContext:context slug:@"hello-slug"];
    album.name = @"Hello Slug";
    
    AlbumUpload *upload = [AlbumUpload createInContext:context];
    upload.album = album;

    [album saveManagedObjectContextLoggingErrors];

    return YES;
}

#pragma mark -
#pragma mark Logout

- (void)startLogout
{
    [self.sync cancel];
    [self.viewCoordinator presentLogoutScreen:YES];
}

#pragma mark -
#pragma mark Lockout

- (BOOL)shouldLockout
{
    return [Partner currentPartner] && [[NSUserDefaults standardUserDefaults] boolForKey:ARLimitedAccess];
}

- (void)updatePartnerMetadataCompletion:(void (^)())completion
{
    [_partnerSync performPartnerMetadataSync:^{
        if (completion) completion();
    }];
}

- (void)lockout
{
    [ARAnalytics event:ARLockoutEvent];
    [self.viewCoordinator presentLockoutScreenContext:[CoreDataManager mainManagedObjectContext]];
}

#pragma mark -
#pragma mark Utils

- (void)checkForCommonDevIssues
{
    // You don't want to know the pain we went through to eventually decide this was worth a check
    if (getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
    }

// https://github.com/groue/GRMustache/blob/master/Guides/runtime.md
#if !defined(NS_BLOCK_ASSERTIONS)
    [GRMustache preventNSUndefinedKeyExceptionAttack];
#endif

    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    BOOL devBuild = [bundleIdentifier hasSuffix:@".dev"];
    [[BITHockeyManager sharedHockeyManager] setDisableUpdateManager:devBuild];
}

- (void)updateExpiredAuthToken
{
    // let them through into the app whilst it re-auths in the background.
    [ARAnalytics event:@"Updating auth token"];
    [self.userManager requestLoginWithStoredCredentials];
}

#pragma mark -
#pragma mark UIApplication Delegate Methods

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[ARSwitchBoard sharedSwitchboard].router routeURL:url];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (![self isInTestingEnvironment] && [Partner currentPartnerID]) {
        [ARAnalytics event:ARSessionStarted];
        [ARAnalytics startTimingEvent:ARSession];


        /// Check to see if they should be locked out each time the app is opened
        if ([[NSUserDefaults standardUserDefaults] boolForKey:ARLimitedAccess]) {
            [self.viewCoordinator presentLockoutScreenContext:[CoreDataManager mainManagedObjectContext]];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ARApplicationDidGoIntoBackground object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [CoreDataManager saveMainContext];

    if (![self isInTestingEnvironment] && [Partner currentPartner]) {
        [ARAnalytics finishTimingEvent:ARSession];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [CoreDataManager saveMainContext];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ARSyncingIsInProgress];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self applicationDidBecomeActive:application];
}

#pragma mark -
#pragma mark Deal with errors

void uncaughtExceptionHandler(NSException *exception)
{
    NSString *error = [NSString stringWithFormat:@"*** Uncaught Exception: %@", exception];

    NSLog(@"%@", error);
    [ARAnalytics event:@"Exception" withProperties:@{ @"Reason" : exception.reason }];
}

- (BOOL)isInTestingEnvironment
{
    return NSClassFromString(@"XCTest") != nil;
}

@end

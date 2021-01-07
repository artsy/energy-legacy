#import "ARLogoutManager.h"
#import "ARFileUtils+FolioAdditions.h"

// These imports are for the hacky album persistance.
// See comment in ARSync's persistAlbums method.
#import "ARTopViewController.h"
#import "ARSync.h"


@interface ARLogoutManager () <UIAlertViewDelegate>
@property (nonatomic, strong) dispatch_queue_t logoutQueue;
@end


@implementation ARLogoutManager

#pragma mark - init

+ (instancetype)sharedLogoutManager
{
    static ARLogoutManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ARLogoutManager alloc] init];
    });

    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _logoutQueue = dispatch_queue_create("com.artsy.folio.logoutQueue", NULL);
    }
    return self;
}

#pragma mark - actions

- (void)run
{
    // Do this on the main thread.
    [ARTopViewController.sharedInstance.sync persistAlbums];

    dispatch_async(self.logoutQueue, ^{

        [ARAnalytics event:ARLogoutEvent];
        [self triggerResetCoreData];
        [self triggerRemoveCurrentPartnerDocuments];
        [self triggerResetUserDefaults];

        // restore the Core Data stack after deleting everything
        // WARNING: restoreCoreDataStack will only work on the main thread

        dispatch_async(dispatch_get_main_queue(), ^{

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Closing Folio", @"Closing Folio")
                                                            message:NSLocalizedString(@"Please re-open to log back in", @"Please re-open to log back in")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Close", @"Close")
                                                  otherButtonTitles:nil];
            [alert show];
        });
    });
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

- (void)triggerResetCoreData
{
    [CoreDataManager resetCoreDataWithSuccess:^{
        NSLog(@"did reset core data");
    } failure:^(NSError *error) {
        NSLog(@"error reseting core data: %@", error);
    }];
}

- (void)triggerResetUserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)triggerRemoveCurrentPartnerDocuments
{
    [ARFileUtils removeCurrentPartnerDocumentsWithCompletion:NULL];
}


@end

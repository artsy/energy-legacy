#import "ARZeroStateMessageViewController.h"
#import "ARBaseViewController+TransparentModals.h"
#import "ARSync.h"

@interface ARZeroStateMessageViewController () <ARSyncDelegate>
@property (nonatomic, strong) ARSync *sync;
@property (nonatomic, weak) IBOutlet UIButton *secondaryCallToActionButton;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation ARZeroStateMessageViewController

- (instancetype)init
{
    self = [super initWithNibName:@"ARFolioMessageViewController" bundle:nil];
    if (!self) { return nil; }

    self.messageText = NSLocalizedString(@"Your Folio experience begins with uploading works to your CMS.", @"Zero state title");
    self.callToActionText = NSLocalizedString(@"Once you've uploaded works, your inventory will be viewable here.", @"Zero state subtitle");
    self.buttonText = NSLocalizedString(@"Visit Your CMS", @"Visit CMS button title");
    self.callToActionAddress = @"https://cms.artsy.net";
    self.secondaryButtonText = @"RETRY";

    __weak typeof(self) weakSelf = self;

    self.secondaryAction = ^(){
        weakSelf.secondaryCallToActionButton.enabled = NO;

        weakSelf.sync = weakSelf.sync ?: [weakSelf setupNewSync];
        weakSelf.sync.delegate = weakSelf;
        [weakSelf.sync sync];
    };

    return self;
}

- (ARSync *)setupNewSync
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSManagedObjectContext *context = [CoreDataManager mainManagedObjectContext];

    ARSync *sync = [[ARSync alloc] init];
    sync.progress = [[ARSyncProgress alloc] init];
    sync.config = [[ARSyncConfig alloc] initWithManagedObjectContext:context defaults:defaults deleter:[[ARSyncDeleter alloc] init]];
    return sync;
}

- (void)syncDidFinish:(ARSync *)sync
{
    self.secondaryCallToActionButton.enabled = YES;

    if ([Partner currentPartnerInContext:self.managedObjectContext].hasUploadedWorks) {
        [self dismissSelf];
    }
}

- (void)dismissSelf
{
    [self.view.window.rootViewController dismissTransparentModalViewControllerAnimated:YES];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

@end

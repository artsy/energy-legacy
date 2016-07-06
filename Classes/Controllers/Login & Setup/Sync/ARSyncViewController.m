#import "ARSyncViewController.h"
#import "ARAppDelegate.h"
#import "ARNavigationController.h"
#import "ARSlideshowImageView.h"
#import "ARDefaults.h"
#import "ARProgressView.h"
#import "NSString+TimeInterval.h"
#import "ARSyncAdminViewController.h"


@interface ARSyncViewController ()

@property (readwrite, nonatomic, strong) NSDate *appearedDate;

@property (nonatomic, strong) IBOutlet UILabel *galleryNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeRemainingLabel;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) IBOutlet ARProgressView *progressView;
@property (nonatomic, strong) IBOutlet UITextView *warningView;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;

@property (nonatomic, strong) IBOutlet ARSlideshowImageView *slideshowView;

@end

// This VC presents some informational text to read
// for a minimum of 30 seconds. Then we switch to showing a slideshow
// of images as they're downloaded.

// Also has a separate 90s idle timer.


@implementation ARSyncViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    NSString *nibName = [UIDevice isPad] ? @"ARSyncViewController" : @"ARPhoneSyncViewController";

    self = [super initWithNibName:nibName bundle:nil];
    if (!self) return nil;

    [self observeNotification:ARLargeImageDownloadCompleteNotification globallyWithSelector:@selector(imageDownloaded:)];
    [self observeNotification:ARAllArtworksDownloadedNotification globallyWithSelector:@selector(allArtworksDownloaded:)];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.continueButton.alpha = 0.2;
    self.slideshowView.backgroundColor = [UIColor blackColor];
    self.galleryNameLabel.text = self.partnerName;
    [self.activityIndicatorView startAnimating];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restoreMaxOpacity)];
    [self.view addGestureRecognizer:tap];

    User *user = [User currentUserInContext:self.managedObjectContext];
    [self.managedObjectContext refreshObject:user mergeChanges:YES];

    _appearedDate = [NSDate date];

    if ([user isAdmin]) {
        UILongPressGestureRecognizer *adminTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showAdminSyncVC:)];
        [self.view addGestureRecognizer:adminTapGesture];
    }
}

- (void)setPartnerName:(NSString *)name
{
    _partnerName = [name uppercaseString];
}

- (void)showAdminSyncVC:(UITapGestureRecognizer *)tapGesture
{
    if (self.navigationController.topViewController != self) {
        return;
    }

    id syncVC = [[ARSyncAdminViewController alloc] init];
    [self.navigationController pushViewController:syncVC animated:YES];
}

#pragma mark -
#pragma mark Inactivity Fadeout

- (BOOL)isShowingProgress
{
    return !self.progressView.hidden;
}

- (BOOL)isShowingSlideshow
{
    return !self.slideshowView.hidden;
}

- (BOOL)canSwitchToSlideshow
{
    return [[NSDate date] timeIntervalSinceDate:self.appearedDate] >= 30;
}

- (void)restoreMaxOpacity
{
    [self restoreMaxOpacityAnimated:YES];
}

static const NSTimeInterval ARSyncViewDimmingDelay = 10;

- (void)restoreMaxOpacityAnimated:(BOOL)animated
{
    [UIView animateIf:animated duration:ARAnimationDuration:^{
        self.view.alpha = 1;
    }];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startDimming) object:nil];
    [self performSelector:@selector(startDimming) withObject:self afterDelay:90];
}

- (void)startDimming
{
    [UIView animateIf:NO duration:ARAnimationDuration:^{
        self.view.alpha = 0.2;
    }];
}

#pragma mark -
#pragma mark Image Transitioning

- (void)imageDownloaded:(NSNotification *)aNotification
{
    NSString *fileName = [aNotification userInfo][@"path"];
    [self.slideshowView addImagePathToQueue:fileName];
}

- (void)allArtworksDownloaded:(NSNotification *)notification
{
    self.continueButton.enabled = YES;
    self.continueButton.alpha = 1;
}

- (IBAction)continueButtonTapped:(id)sender
{
    [self syncDidFinish:nil];
}

#pragma mark -
#pragma mark Properties

- (NSString *)status
{
    return self.statusLabel.text;
}

- (void)setStatus:(NSString *)aString
{
    self.statusLabel.text = aString;
}

#pragma mark - ARSyncProgressDelegate

- (void)syncDidProgress:(ARSyncProgress *)progress
{
    CGFloat percentDone = progress.percentDone;
    self.progressView.progress = percentDone;

    NSTimeInterval timeRemaining = [progress estimatedTimeRemaining];
    NSTimeInterval oneDay = 86400;
    self.timeRemainingLabel.text = [NSString cappedStringForTimeInterval:timeRemaining cap:oneDay];

    // show all the progress labels after we hit 0.01%

    if (!self.isShowingProgress && percentDone >= 0.01) {
        self.activityIndicatorView.hidden = YES;
        self.progressView.hidden = NO;
        self.statusLabel.hidden = NO;
        self.timeRemainingLabel.hidden = NO;
    }

    // show the slideshow if there's images, and it's been
    // over 30 seconds

    if (self.canSwitchToSlideshow && self.slideshowView.hasImages && !self.isShowingSlideshow) {
        self.slideshowView.hidden = NO;
        [self.slideshowView start];

        self.warningView.hidden = YES;

        [self performSelector:@selector(startDimming) withObject:self afterDelay:ARSyncViewDimmingDelay];
    }
}

#pragma mark -
#pragma mark ARSyncDelegate Methods

- (void)syncDidFinish:(ARSync *)sync
{
    [self.slideshowView stop];

    if (_completionBlock) {
        _completionBlock();
    }
}

#pragma mark -
#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [UIDevice isPad];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

@end

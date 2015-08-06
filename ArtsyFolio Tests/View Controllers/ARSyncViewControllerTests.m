#import "ARSyncViewController.h"
#import "ARProgressView.h"
#import "ARSlideshowImageView.h"
#import "ARDefaults.h"


@interface ARSyncViewController (Private)
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readwrite, nonatomic, strong) NSDate *appearedDate;
@property (nonatomic, strong) IBOutlet ARProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *timeRemainingLabel;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;
@property (nonatomic, strong) IBOutlet ARSlideshowImageView *slideshowView;

- (IBAction)continueButtonTapped:(id)sender;
@end


@interface ARFakeSyncProgress : NSObject
@property (readwrite, nonatomic, assign) CGFloat percentDone;
@property (readwrite, nonatomic, assign) NSTimeInterval estimatedTimeRemaining;
@end


@implementation ARFakeSyncProgress
@end

SpecBegin(ARSyncViewController);

__block ARSyncViewController *sut;
__block NSString *localImagePath;

itHasSnapshotsForDevices(@"init", ^{
    sut = [[ARSyncViewController alloc] init];
    sut.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
    return sut;
});

describe(@"continue", ^{
    before(^{
        sut = [[ARSyncViewController alloc] init];
        sut.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];

        [sut loadViewsProgrammatically];
    });

    it(@"has a disabled continue button at first", ^{
        expect(sut.continueButton.enabled).to.beFalsy();
        expect(sut.continueButton.alpha).toNot.equal(1.0);
    });

    it(@"becomes visible when recieving a ARAllArtworksDownloadedNotification", ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ARAllArtworksDownloadedNotification object:nil userInfo:nil];

        expect(sut.continueButton.enabled).to.beTruthy();
        expect(sut.continueButton.alpha).to.equal(1.0);
    });
});

describe(@"syncing", ^{
    before(^{
        sut = [[ARSyncViewController alloc] init];
        sut.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];

        localImagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"example-image" ofType:@"png"];

        [sut loadViewsProgrammatically];
    });

    it(@"shows the progress", ^{
        ARFakeSyncProgress *progress = [[ARFakeSyncProgress alloc] init];
        progress.estimatedTimeRemaining = 500;
        progress.percentDone = 0.5;

        [sut syncDidProgress:(id)progress];

        expect(sut.progressView.progress).to.equal(0.5);
        expect(sut.timeRemainingLabel.text).to.equal(@"8 minutes");
    });

    it(@"shows the progress when getting progress notifications", ^{
        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            ARFakeSyncProgress *progress = [[ARFakeSyncProgress alloc] init];
            progress.estimatedTimeRemaining = 500;
            progress.percentDone = 0.5;

            [sut syncDidProgress:(id)progress];
            expect(sut).to.haveValidSnapshot();
        }];
    });

    it(@"sends local paths to the slideshow", ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ARLargeImageDownloadCompleteNotification object:nil userInfo:@{ @"path": localImagePath }];
        expect(sut.slideshowView.hasImages).to.beTruthy();
    });

    it(@"shows slideshow after 30 seconds and a sync progress", ^{
        expect(sut.canSwitchToSlideshow).to.beFalsy();
        sut.appearedDate = [NSDate distantPast];
        expect(sut.canSwitchToSlideshow).to.beTruthy();
    });

    it(@"shows the slideshow if after 30 sec, has a filepath and has a percentage ", ^{
        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            sut.appearedDate = [NSDate distantPast];

            ARFakeSyncProgress *progress = [[ARFakeSyncProgress alloc] init];
            progress.estimatedTimeRemaining = 500;
            progress.percentDone = 0.5;

            [[NSNotificationCenter defaultCenter] postNotificationName:ARLargeImageDownloadCompleteNotification object:nil userInfo:@{ @"path": localImagePath }];
            [[NSNotificationCenter defaultCenter] postNotificationName:ARAllArtworksDownloadedNotification object:nil userInfo:nil];

            [sut syncDidProgress:(id)progress];
            expect(sut).to.haveValidSnapshot();
        }];
    });
});

SpecEnd

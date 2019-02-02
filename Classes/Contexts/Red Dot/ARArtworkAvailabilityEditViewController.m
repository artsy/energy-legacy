#import "ARArtworkAvailabilityEditViewController.h"
#import "ARPresentAvailabilityChoiceViewController.h"
#import "UIViewController+SimpleChildren.h"
#import "AREditAvailabilityNetworkModel.h"
#import "ARPopoverController.h"
#import "AREditEditionsViewController.h"


@interface ARArtworkAvailabilityEditViewController ()
@property (strong) ARPresentAvailabilityChoiceViewController *noEditionsInlineAvailabilityOptionsVC;
@property (strong) AREditEditionsViewController *editEditionsVC;
@property (strong) ARPopoverController *popover;
@property (strong) AREditAvailabilityNetworkModel *networkModel;
@end


@implementation ARArtworkAvailabilityEditViewController

- (instancetype)initWithArtwork:(Artwork *)artwork popover:(nonnull ARPopoverController *)popover
{
    self = [super init];
    if (!self) {
        return self;
    }

    _artwork = artwork;
    _popover = popover;

    AREditAvailabilityNetworkModel *networkModel = [[AREditAvailabilityNetworkModel alloc] init];
    _networkModel = networkModel;

    if (artwork.editionSets.count) {
        _editEditionsVC = [[AREditEditionsViewController alloc] initWithArtwork:artwork popover:popover];

    } else {
        // When there are no editions, just show the artwork availablilty inline
        _noEditionsInlineAvailabilityOptionsVC = [[ARPresentAvailabilityChoiceViewController alloc] init];
        _noEditionsInlineAvailabilityOptionsVC.currentAvailability = _artwork.availabilityState;
        _noEditionsInlineAvailabilityOptionsVC.callback = ^(ARArtworkAvailability newAvailability, AvailabilityFinishedCallback _Nonnull finished) {
            [networkModel updateArtwork:artwork mainAvailability:newAvailability completion:^(BOOL success) {
                // Update the UI in the popover
                finished(success);

                if (success) {
                    // Update the core data model, then tell all grids and artwork pages to reload
                    artwork.availability = [Artwork stringForAvailabilityState:newAvailability];
                    [artwork saveManagedObjectContextLoggingErrors];

                    // Hide the popover after it's confirmed
                    ar_dispatch_after(0.35, ^{
                        [popover dismissPopoverAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ARArtworkAvailabilityUpdated object:artwork];
                    });
                }
            }];
        };
    }

    return self;
}

- (UIViewController *)mainViewController
{
    return self.noEditionsInlineAvailabilityOptionsVC ?: self.editEditionsVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self ar_addModernChildViewController:self.mainViewController];
    [self.mainViewController.view alignToView:self.view];
}

- (CGSize)preferredContentSize
{
    return self.mainViewController.preferredContentSize;
}

@end

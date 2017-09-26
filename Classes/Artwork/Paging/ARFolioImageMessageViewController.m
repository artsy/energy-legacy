#import "ARFolioImageMessageViewController.h"

#if __has_include(<SafariServices/SFSafariViewController.h>)
#import <SafariServices/SFSafariViewController.h>


@interface ARFolioImageMessageViewController () <SFSafariViewControllerDelegate>

#else

// To ensure CI we need to support older SDKs without SFSafariVC
@interface ARFolioImageMessageViewController ()
#endif


@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *callToActionButton;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@end


@implementation ARFolioImageMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.messageLabel setText:self.messageText];
    [self.callToActionButton setTitle:self.buttonText forState:UIControlStateNormal];
    [self.imageView setImage:self.image];
}

- (IBAction)closeButtonPressed:(UIButton *)sender
{
    [self.delegate dismissMessageViewController];
}

- (IBAction)callToActionButtonPressed:(UIButton *)sender
{
#if __has_include(<SafariServices/SFSafariViewController.h>)
    if (!NSClassFromString(@"SFSafariViewController")) {
        [[UIApplication sharedApplication] openURL:self.url];
        return;
    };

    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:self.url entersReaderIfAvailable:NO];
    safariVC.delegate = self;
    safariVC.view.tintColor = [UIColor artsyPurpleRegular];
    [self presentViewController:safariVC animated:YES completion:nil];
#else
    [[UIApplication sharedApplication] openURL:self.url];
#endif
}

#if __has_include(<SafariServices/SFSafariViewController.h>)

- (void)safariViewControllerDidFinish:(nonnull SFSafariViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self closeButtonPressed:nil];
    }];
}

#endif
@end

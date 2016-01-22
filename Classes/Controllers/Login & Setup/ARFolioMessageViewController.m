
#import "ARFolioMessageViewController.h"


@interface ARFolioMessageViewController ()

@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *callToActionLabel;
@property (nonatomic, weak) IBOutlet UIButton *callToActionButton;
@property (nonatomic, weak) IBOutlet UIButton *secondaryCallToActionButton;

@end


@implementation ARFolioMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.messageLabel setText:self.messageText];
    [self.callToActionLabel setText:self.callToActionText];
    [self.callToActionButton setTitle:self.buttonText forState:UIControlStateNormal];
    [self.secondaryCallToActionButton setTitle:self.secondaryButtonText forState:UIControlStateNormal];
    self.secondaryCallToActionButton.hidden = self.secondaryAction == nil;

    if ([UIDevice isPad]) {
        [self.messageLabel setFont:[UIFont serifFontWithSize:40]];
        [self.callToActionLabel setFont:[UIFont serifFontWithSize:20]];
    }
}

- (IBAction)applyButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.callToActionAddress]];
}

- (IBAction)secondaryActionButtonTapped:(id)sender
{
    self.secondaryAction();
}

@end

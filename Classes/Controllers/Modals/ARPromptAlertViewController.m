

#import "ARPromptAlertViewController.h"


@implementation ARPromptAlertViewController

- (instancetype)init
{
    return [super initWithNibName:@"ARPromptAlertViewController" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![UIDevice isPad]) {
        self.alertView.frame = CGRectOffset(self.alertView.frame, 0, -120);
    }

    self.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    self.actionButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    self.cancelButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];

    self.inputTextField.contentInset = UIEdgeInsetsMake(1, 6, 1, 1);
    self.inputTextField.font = [UIFont serifFontWithSize:ARFontSerif];
    self.inputTextField.delegate = self;
    self.inputTextField.superview.backgroundColor = [UIColor artsyMediumGrey];

    self.actionButton.enabled = NO;
    self.actionButton.alpha = 0.3;

    [self.inputTextField becomeFirstResponder];
}

- (IBAction)actionPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(modalViewController:didReturnStatus:)]) {
        [self.delegate modalViewController:self didReturnStatus:ARModalAlertOK];
    }
}

- (IBAction)cancelPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(modalViewController:didReturnStatus:)]) {
        [self.delegate modalViewController:self didReturnStatus:ARModalAlertCancel];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSAssert(NO, @"%@ must be overridden in ARPromptAlertViewController", NSStringFromSelector(_cmd));
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.actionButton.enabled) {
        [self actionPressed:self];
    }
    return YES;
}
@end

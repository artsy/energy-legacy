#import "ARNewAlbumModalViewController.h"


@implementation ARNewAlbumModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLabel.text = @"CREATE NEW ALBUM";
    [self.actionButton setTitle:@"CREATE" forState:UIControlStateNormal];

    self.inputTextField.placeholder = @"Album Name";
    self.inputTextField.tintColor = [UIColor artsyPurple];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger length = textField.text.length + string.length - range.length;
    if (length > 0) {
        self.actionButton.enabled = YES;
        self.actionButton.alpha = 1;
    } else {
        self.actionButton.enabled = NO;
        self.actionButton.alpha = 0.3;
    }
    return YES;
}

@end

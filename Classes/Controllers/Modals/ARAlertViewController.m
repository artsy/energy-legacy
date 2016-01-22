

#import "ARAlertViewController.h"


@implementation ARAlertViewController

- (instancetype)initWithCompletionBlock:(void (^)(enum ARModalAlertViewControllerStatus))completionBlock
{
    self = [super init];
    if (self) {
        completion = completionBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = self.alertText;

    [saveButton setTitle:self.okTitle forState:UIControlStateNormal];
    [cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];

    titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    saveButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    cancelButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
}

- (IBAction)savePressed:(id)sender
{
    completion(ARModalAlertOK);
}

- (IBAction)cancelPressed:(id)sender
{
    completion(ARModalAlertCancel);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

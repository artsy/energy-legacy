#import "ARAlertViewController.h"
#import "ARInsetTextField.h"


@interface ARPromptAlertViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<ARModalAlertViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet ARInsetTextField *inputTextField;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *actionButton;
@property (nonatomic, weak) IBOutlet UIView *alertView;

- (IBAction)actionPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end

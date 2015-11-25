#import "ARLabSettingsEmailViewController.h"
#import "ARLabSettingsEmailViewModel.h"
#import "NSString+NiceAttributedStrings.h"

@interface ARLabSettingsEmailViewController()
@property (nonatomic, strong) ARLabSettingsEmailViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextView *ccEmailTextView;
@property (weak, nonatomic) IBOutlet UITextView *greetingTextView;
@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;

@property (weak, nonatomic) IBOutlet UILabel *signatureExplanatoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ARLabSettingsEmailViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewWillLayoutSubviews];
    
    self.viewModel = [[ARLabSettingsEmailViewModel alloc] init];
    [self setupTextViews];
    
    NSAttributedString *signatureLabelText = [self.viewModel.signatureExplanatoryText attributedStringWithLineSpacing:5];
    [self.signatureExplanatoryLabel setAttributedText:signatureLabelText];
   
    [@[self.ccEmailTextView, self.greetingTextView, self.signatureTextView] each:^(UITextView *textView) {
        textView.layer.borderColor = [UIColor artsyLightGrey].CGColor;
        textView.layer.borderWidth = 2.0;
        
        textView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.textContainer.lineFragmentPadding = 10;
    }];
    
}

- (void)setupTextViews
{
    self.ccEmailTextView.text = [self.viewModel savedStringForEmailDefault:AREmailCCEmail];
    self.greetingTextView.text = [self.viewModel savedStringForEmailDefault:AREmailGreeting];
    self.signatureTextView.text = [self.viewModel savedStringForEmailDefault:AREmailSignature];
}

#pragma mark - 
#pragma mark textViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.layer.borderColor = [UIColor artsyPurple].CGColor;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.layer.borderColor = [UIColor artsyLightGrey].CGColor;
    
    if (textView == self.ccEmailTextView) [self.viewModel setEmailDefault:self.ccEmailTextView.text WithKey:AREmailCCEmail];
    else if (textView == self.greetingTextView) [self.viewModel setEmailDefault:self.greetingTextView.text WithKey:AREmailGreeting];
    else if (textView == self.signatureTextView) [self.viewModel setEmailDefault:self.signatureTextView.text WithKey:AREmailSignature];
}

@end

#import "AREmailSubjectLineSettingsViewController.h"

#import "ARNavigationBar.h"
#import "UIViewController+SettingsNavigationItemHelpers.h"
#import "NSString+NiceAttributedStrings.h"


@interface AREmailSubjectLineSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeExplanatoryLabel;

@property (nonatomic, assign) AREmailSubjectType subjectType;
@property (nonatomic, strong) AREmailSettingsViewModel *viewModel;

@end


@implementation AREmailSubjectLineSettingsViewController

- (void)setupWithSubjectType:(AREmailSubjectType)subjectType viewModel:(AREmailSettingsViewModel *)viewModel
{
    _subjectType = subjectType;
    _viewModel = viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.subjectTypeTitleLabel.text = [self.viewModel titleForEmailSubjectType:self.subjectType].uppercaseString;
    self.subjectTypeExplanatoryLabel.attributedText = [[self.viewModel explanatoryTextForSubjectType:self.subjectType] attributedStringWithLineSpacing:5];

    [self setupNavigationBar];
    [self setupTextView];
}

#pragma mark -
#pragma mark navigation bar modifications

- (void)setupNavigationBar
{
    [self addSettingsBackButtonWithTarget:@selector(popViewController) animated:YES];
    self.title = NSLocalizedString(@"Subject Lines", @"Title for email subject lines view controller").uppercaseString;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark textView modifications

- (void)setupTextView
{
    self.textView.text = [self.viewModel savedStringForSubjectType:self.subjectType];

    self.textView.layer.borderColor = [UIColor artsyLightGrey].CGColor;
    self.textView.layer.borderWidth = 2.0;

    self.textView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.textContainer.lineFragmentPadding = 10;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.layer.borderColor = [UIColor artsyPurple].CGColor;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.layer.borderColor = [UIColor artsyLightGrey].CGColor;

    [self.viewModel saveSubjectLine:textView.text ForType:self.subjectType];
}

@end

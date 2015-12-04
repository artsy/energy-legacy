#import "ARLabSettingsEmailSubjectLinesViewController.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "ARNavigationBar.h"


@interface ARLabSettingsEmailSubjectLinesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeExplanatoryLabel;

@property (nonatomic, assign) AREmailSubjectType subjectType;
@property (nonatomic, strong) ARLabSettingsEmailViewModel *viewModel;

@end


@implementation ARLabSettingsEmailSubjectLinesViewController

- (void)setupWithSubjectType:(AREmailSubjectType)subjectType viewModel:(ARLabSettingsEmailViewModel *)viewModel
{
    _subjectType = subjectType;
    _viewModel = viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Subject", @"Title for email subject view controller").uppercaseString;

    self.subjectTypeTitleLabel.text = [self.viewModel titleForEmailSubjectType:self.subjectType];
    self.subjectTypeExplanatoryLabel.text = [self.viewModel explanatoryTextForSubjectType:self.subjectType];

    [self setupNavigationBar];
    [self setupTextView];
}

#pragma mark -
#pragma mark navigation bar modifications

- (void)setupNavigationBar
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;

    navigationBar.barTintColor = [UIColor whiteColor];
    navigationBar.tintColor = [UIColor blackColor];

    [navigationBar setTitleTextAttributes:
                       @{NSForegroundColorAttributeName : [UIColor blackColor],
                         NSFontAttributeName : [UIFont sansSerifFontWithSize:20]}];

    [self addBackButton];
    [self hideBottomBorder];
}

- (void)hideBottomBorder
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)addBackButton
{
    if ([self.navigationController.viewControllers count] > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"MenuBack"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"MenuBackSelected"] forState:UIControlStateHighlighted];
        backButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansSmall];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0, 0, 80, 40);
        backButton.accessibilityLabel = @"SettingsBackButton";
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
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

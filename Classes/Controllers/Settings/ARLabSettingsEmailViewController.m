#import "ARLabSettingsEmailViewController.h"
#import "NSString+NiceAttributedStrings.h"
#import "ARTableViewCell.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "ARStoryboardIdentifiers.h"
#import "ARLabSettingsEmailSubjectLinesViewController.h"


@interface ARLabSettingsEmailViewController ()
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

    _viewModel = _viewModel ?: [[ARLabSettingsEmailViewModel alloc] initWithDefaults:[NSUserDefaults standardUserDefaults]];

    [self setupTextViews];

    NSAttributedString *signatureLabelText = [self.viewModel.signatureExplanatoryText attributedStringWithLineSpacing:5];
    [self.signatureExplanatoryLabel setAttributedText:signatureLabelText];

    /// This deals with the default left margin in the table view cells
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, -15.0f, 0.0f, 0.0f);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)setupTextViews
{
    [@[ self.ccEmailTextView, self.greetingTextView, self.signatureTextView ] each:^(UITextView *textView) {
        textView.layer.borderColor = [UIColor artsyLightGrey].CGColor;
        textView.layer.borderWidth = 2.0;
        
        textView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.textContainer.lineFragmentPadding = 10;
    }];

    self.ccEmailTextView.text = [self.viewModel savedStringForEmailDefault:AREmailCCEmail];
    self.greetingTextView.text = [self.viewModel savedStringForEmailDefault:AREmailGreeting];
    self.signatureTextView.text = [self.viewModel savedStringForEmailDefault:AREmailSignature];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EmailSubjectReuseIdentifier];

    cell.textLabel.font = [UIFont serifFontWithSize:14];
    cell.textLabel.text = [self.viewModel titleForEmailSubjectType:indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:ARLabSettingsEmailSubjectLinesViewController.class]) {
        AREmailSubjectType selectedType = [self.tableView indexPathForSelectedRow].row;
        [(ARLabSettingsEmailSubjectLinesViewController *)segue.destinationViewController setupWithSubjectType:selectedType viewModel:self.viewModel];
    }
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

    if (textView == self.ccEmailTextView)
        [self.viewModel setEmailDefault:self.ccEmailTextView.text WithKey:AREmailCCEmail];
    else if (textView == self.greetingTextView)
        [self.viewModel setEmailDefault:self.greetingTextView.text WithKey:AREmailGreeting];
    else if (textView == self.signatureTextView)
        [self.viewModel setEmailDefault:self.signatureTextView.text WithKey:AREmailSignature];
}

@end

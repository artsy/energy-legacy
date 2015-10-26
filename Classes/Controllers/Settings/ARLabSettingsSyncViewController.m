#import "ARLabSettingsSyncViewController.h"
#import "ARFlatButton.h"
#import "ARSyncStatusViewModel.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>


@interface ARLabSettingsSyncViewController ()

@property (nonatomic, strong) ARSyncStatusViewModel *viewModel;

@property (weak, nonatomic) IBOutlet ARSyncFlatButton *syncButton;
@property (weak, nonatomic) IBOutlet UILabel *explanatoryTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousSyncsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation ARLabSettingsSyncViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.syncButton setTitle:@"Sync Content".uppercaseString forState:UIControlStateNormal];

    NSString *string = self.explanatoryTextLabel.text;
    [self.explanatoryTextLabel setAttributedText:[self expandedLineHeightBodyTextForString:string]];

    NSString *previousSyncsText = self.viewModel.syncLogCount ? @"Previous Syncs" : @"You have no previous syncs";
    [self.previousSyncsLabel setAttributedText:[self expandedKernTextForString:previousSyncsText.uppercaseString]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel syncLogCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"previousSyncCell"];

    NSArray *dateStrings = self.viewModel.previousSyncDateStrings;
    if (dateStrings) {
        cell.textLabel.text = dateStrings[indexPath.row];
        cell.textLabel.font = [UIFont serifFontWithSize:15];
        cell.textLabel.textColor = UIColor.artsyHeavyGrey;
    }

    return cell;
}
- (IBAction)syncButtonPressed:(id)sender
{
    [self.viewModel startSync];
    [self.tableView reloadData];
}

- (NSAttributedString *)expandedLineHeightBodyTextForString:(NSString *)string
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    return attrString;
}

- (NSAttributedString *)expandedKernTextForString:(NSString *)string
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSKernAttributeName value:@(1.5) range:NSMakeRange(0, string.length)];
    return attrString;
}

- (ARSyncStatusViewModel *)viewModel
{
    return _viewModel ?: [[ARSyncStatusViewModel alloc] initWithSync:nil];
}

@end

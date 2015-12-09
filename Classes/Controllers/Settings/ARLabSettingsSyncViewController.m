#import "ARLabSettingsSyncViewController.h"
#import "ARFlatButton.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "ARTopViewController.h"
#import "NSString+NiceAttributedStrings.h"
#import "ARSyncStatusViewModel.h"
#import "ARNetworkQualityIndicator.h"


@interface ARLabSettingsSyncViewController ()

@property (weak, nonatomic) IBOutlet ARSyncFlatButton *syncButton;
@property (weak, nonatomic) IBOutlet UILabel *explanatoryTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousSyncsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *previousSyncDateStrings;
@end


@implementation ARLabSettingsSyncViewController

@synthesize section;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    self.section = ARLabSettingsSectionSync;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:[UIDevice isPad]];

    self.previousSyncDateStrings = self.viewModel.previousSyncDateStrings;
    [self.syncButton setTitle:@"Sync Content".uppercaseString forState:UIControlStateNormal];

    NSString *string = self.explanatoryTextLabel.text;
    self.explanatoryTextLabel.attributedText = [string attributedStringWithLineSpacing:10.0];

    NSString *previousSyncsText = self.viewModel.syncLogCount ? @"Previous Syncs" : @"You have no previous syncs";
    [self.previousSyncsLabel setAttributedText:[self expandedKernTextForString:previousSyncsText.uppercaseString]];

    self.qualityIndicator = self.qualityIndicator ?: [[ARNetworkQualityIndicator alloc] init];
    [self.qualityIndicator beginObservingNetworkQuality:^(ARNetworkQuality quality) {
        NSLog(@"NETWORK Q: %@", @(quality));
    }];
}

- (void)dealloc
{
    [self.qualityIndicator stopObservingNetworkQuality];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel syncLogCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"previousSyncCell"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.previousSyncDateStrings) {
        cell.textLabel.text = self.previousSyncDateStrings[indexPath.row];
        cell.textLabel.font = [UIFont serifFontWithSize:15];
        cell.textLabel.textColor = UIColor.artsyHeavyGrey;
    }
}

- (IBAction)syncButtonPressed:(id)sender
{
    [self.viewModel startSync];
}

- (NSAttributedString *)expandedKernTextForString:(NSString *)string
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSKernAttributeName value:@(1.5) range:NSMakeRange(0, string.length)];
    return attrString;
}

@end

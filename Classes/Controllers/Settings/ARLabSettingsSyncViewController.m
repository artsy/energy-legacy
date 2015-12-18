#import "ARLabSettingsSyncViewController.h"
#import "ARFlatButton.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "ARTopViewController.h"
#import "NSString+NiceAttributedStrings.h"
#import "ARSyncStatusViewModel.h"
#import "ARNetworkQualityIndicator.h"
#import "UIViewController+SettingsNavigationItemHelpers.h"
#import "ARSettingsNavigationBar.h"


@interface ARLabSettingsSyncViewController ()
@property (nonatomic, strong) ARSyncStatusViewModel *viewModel;

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

    self.title = @"Sync Content".uppercaseString;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNavigationBar];

    self.previousSyncDateStrings = self.viewModel.previousSyncDateStrings;
    [self.syncButton setTitle:@"Sync Content".uppercaseString forState:UIControlStateNormal];

    NSString *string = self.explanatoryTextLabel.text;
    self.explanatoryTextLabel.attributedText = [string attributedStringWithLineSpacing:7.0];

    NSString *previousSyncsText = self.viewModel.syncLogCount ? @"Previous Syncs" : @"You have no previous syncs";
    [self.previousSyncsLabel setAttributedText:[previousSyncsText.uppercaseString attributedStringWithKern:1.3]];

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
    [attrString addAttribute:NSKernAttributeName value:@(1.3) range:NSMakeRange(0, string.length)];
    return attrString;
}

- (void)setupNavigationBar
{
    if ([UIDevice isPhone]) [self addSettingsBackButtonWithTarget:@selector(returnToMasterViewController) animated:YES];
}

- (void)returnToMasterViewController
{
    [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
}

- (ARSyncStatusViewModel *)viewModel
{
    return _viewModel ?: [[ARSyncStatusViewModel alloc] initWithSync:ARTopViewController.sharedInstance.sync context:CoreDataManager.mainManagedObjectContext];
}

@end

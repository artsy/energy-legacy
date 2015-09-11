#import "ARMailSettingsViewController.h"
#import "ARSupportSettingsViewController.h"
#import "ARSettingsViewController.h"
#import "Reachability+ConnectionExists.h"
#import "ARTableViewCell.h"
#import "ARFlatButton.h"
#import "ARToggleSwitch.h"
#import "NSString+TimeInterval.h"
#import "NSDate+Presentation.h"

NS_ENUM(NSInteger, Sections){
    SettingsNavigationSection,
    SyncingSection};

NS_ENUM(NSInteger, NavigationSettingsSectionRows){
    EmailSettingsNavigationRow,
    AdminSettingsNavigationRow,
};

typedef NS_ENUM(NSInteger, ARSyncStatus) {
    ARSyncStatusUpToDate,
    ARSyncStatusRecommendSync,
    ARSyncStatusOffline,
    ARSyncStatusSyncing,
};

static const NSInteger kNumberOfSections = 2;
static const NSInteger kNumberOfRowsInSettingsSection = 2;
static const NSInteger kNumberOfRowsInSyncingSection = 1;
static const NSInteger kHeightOfTitleBar = 64;
static const NSInteger kHeightOfSettingsCell = 130;


@interface ARSettingsViewController ()
@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) IBOutlet UITableViewCell *syncViewCell;
@property (nonatomic, weak) IBOutlet UILabel *syncStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *syncStatusSubtitleLabel;

@property (nonatomic, weak) IBOutlet ARFlatButton *syncButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *syncActivityView;
@property (nonatomic, weak) IBOutlet UIImageView *syncNotificationImage;

@property (nonatomic, assign) BOOL isOffline;

@end


@implementation ARSettingsViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    NSString *title = NSLocalizedString(@"Settings", @"Settings title");
    self.title = [title uppercaseString];

    return self;
}

#pragma mark -
#pragma mark view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSyncUI];

    self.tableView.accessibilityLabel = @"Settings TableView";

    [self registerForNotifications];
}

- (void)viewDidUnload
{
    self.syncActivityView = nil;
    [super viewDidUnload];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetSyncButton:)
                                                 name:ARNotEnoughDiskSpaceNotification
                                               object:nil];


    // we know ARAppDelegate started the notifier, so no need to do it here
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    for (UITableViewCell *cell in self.tableView.visibleCells) {
        [cell setSelected:NO animated:NO];
    }

    [self setupSyncUI];
}

- (void)resetSyncButton:(NSNotification *)aNotification
{
    [self setupSyncUI];
    self.syncStatusLabel.text = @"";
}

- (void)reachabilityChanged:(NSNotification *)aNotification
{
    BOOL offline = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable;
    if (offline != self.isOffline) {
        _isOffline = offline;
        [self setupSyncUI];

        // Going from offline to online, it'll fix itself
        if (self.isOffline) {
            self.syncStatusLabel.text = @"Syncing paused: no Internet connection";
        }
    }
}

#pragma mark -
#pragma mark table view cell configuring

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == EmailSettingsNavigationRow) {
        cell.textLabel.text = @"Email Settings";

    } else if (indexPath.row == AdminSettingsNavigationRow) {
        cell.textLabel.text = @"Admin & Support";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark table view delegate

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = SettingsCellReuse;
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];

    if (indexPath.section != SyncingSection) {
        if (cell == nil) {
            cell = [[ARTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }

    else {
        // We have the _syncViewCell in the nib.
        cell = self.syncViewCell;
        self.syncStatusLabel.font = [UIFont serifFontWithSize:ARFontSerif];
        self.syncStatusSubtitleLabel.font = [UIFont serifFontWithSize:ARFontSerifSmall];
        self.syncStatusSubtitleLabel.textColor = [UIColor artsyHeavyGrey];
    }

    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SyncingSection) return;

    if (indexPath.row == EmailSettingsNavigationRow) {
        ARMailSettingsViewController *mailVC = [[ARMailSettingsViewController alloc] init];
        [self.navigationController pushViewController:mailVC animated:YES];

    } else if (indexPath.row == AdminSettingsNavigationRow) {
        ARSupportSettingsViewController *adminSettingsVC = [[ARSupportSettingsViewController alloc] init];
        [self.navigationController pushViewController:adminSettingsVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SettingsNavigationSection:
            return kNumberOfRowsInSettingsSection;
        case SyncingSection:
            return kNumberOfRowsInSyncingSection;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SyncingSection) {
        return CGRectGetHeight([self.syncViewCell frame]);
    }
    return ARTableViewCellSettingsHeight;
}

#pragma mark -
#pragma mark sync controller actions

- (void)syncDidProgress:(ARSyncProgress *)progress
{
    NSTimeInterval remaining = progress.estimatedTimeRemaining;
    NSTimeInterval oneDay = 86400;
    self.syncStatusLabel.text = [NSString cappedStringForTimeInterval:remaining cap:oneDay];
}

- (IBAction)sync:(id)sender
{
    if (ARIsOSSBuild) {
        self.syncStatusLabel.text = @"Sync is disabled on OSS builds.";
        return;
    }

    [self.sync sync];
    [ARAnalytics event:ARManualSyncStartEvent];

    self.syncButton.enabled = NO;
    [self setupForSyncInProgress];
}

- (void)syncDidFinish:(ARSync *)sync
{
    [self setupSyncUI];
    [self enableSyncButton];
}

- (ARSyncStatus)syncStatus
{
    BOOL isSyncing = self.sync.isSyncing;
    self.sync.delegate = self;

    self.isOffline = ![Reachability connectionExists];

    if (self.isOffline) {
        return ARSyncStatusOffline;
    } else if (isSyncing) {
        return ARSyncStatusSyncing;
    } else if ([self.defaults boolForKey:ARRecommendSync]) {
        return ARSyncStatusRecommendSync;
    } else {
        return ARSyncStatusUpToDate;
    }
}

#pragma mark -
#pragma mark UI setup

- (void)setupSyncUI
{
    self.syncActivityView.alpha = 0;

    switch (self.syncStatus) {
        case ARSyncStatusOffline:
            [self setupForNoConnectivity];
            break;

        case ARSyncStatusRecommendSync:
            [self setupWithSyncRecommendation];
            break;

        case ARSyncStatusSyncing:
            [self setupForSyncInProgress];
            break;

        case ARSyncStatusUpToDate:
            [self setupForContentUpToDate];
            break;
    }
}

- (void)setupWithSyncRecommendation
{
    self.syncButton.backgroundColor = [UIColor artsyPurple];
    self.syncButton.borderColor = [UIColor artsyPurple];
    [self enableSyncButton];

    self.syncStatusLabel.text = NSLocalizedString(@"New Content in CMS", @"New content in CMS label");
    self.syncStatusSubtitleLabel.text = [self lastSyncedString];

    self.syncNotificationImage.layer.cornerRadius = self.syncNotificationImage.frame.size.height / 2;
    self.syncNotificationImage.backgroundColor = [UIColor artsyPurple];
}

- (void)setupForSyncInProgress
{
    self.syncActivityView.alpha = 1;
    self.syncStatusLabel.text = NSLocalizedString(@"Sync in progress...", @"Sync is in progress string with ellipses");

    self.syncButton.alpha = 0;
    self.syncStatusSubtitleLabel.alpha = 0;
    self.syncNotificationImage.alpha = 0;
}

- (void)setupForContentUpToDate
{
    self.syncStatusLabel.text = NSLocalizedString(@"Content is up to date", @"All content up-to-date string");
    self.syncStatusSubtitleLabel.text = [self lastSyncedString];
    self.syncStatusSubtitleLabel.alpha = 1;

    NSString *buttonText = NSLocalizedString(@"Sync Content", @"Sync button text after syncing completed");
    [self.syncButton setTitle:buttonText forState:UIControlStateNormal];
    [self enableSyncButton];

    UIImage *check = [[UIImage imageNamed:@"check-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.syncNotificationImage.image = check;
    self.syncNotificationImage.tintColor = [UIColor artsyHighlightGreen];
    self.syncNotificationImage.backgroundColor = [UIColor clearColor];
    self.syncNotificationImage.alpha = 1;
}

- (void)setupForNoConnectivity
{
    self.syncStatusLabel.text = [self lastSyncedString];
    self.syncStatusSubtitleLabel.text = NSLocalizedString(@"Syncing is not available offline", @"Label that tells user they cannot sync without a network connection");

    self.syncButton.alpha = 0.5;
    self.syncButton.userInteractionEnabled = NO;

    self.syncActivityView.alpha = 0;
    self.syncNotificationImage.alpha = 0;
}

- (void)enableSyncButton
{
    self.syncButton.alpha = 1.0;
    self.syncButton.userInteractionEnabled = YES;
}

- (NSString *)lastSyncedString
{
    NSDate *lastSynced = [self.defaults objectForKey:ARLastSyncDate];
    if (lastSynced) {
        NSString *lastSyncedFormat = NSLocalizedString(@"Last synced %@", @"Text for saying the last time you synced was %@");
        return [NSString stringWithFormat:lastSyncedFormat, [lastSynced formattedString]];
    }
    return @"";
}

- (CGSize)preferredContentSize
{
    CGFloat contentHeight = kNumberOfRowsInSettingsSection * ARTableViewCellSettingsHeight;
    contentHeight += kHeightOfTitleBar;
    contentHeight += kHeightOfSettingsCell;
    return CGSizeMake(320, contentHeight);
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end

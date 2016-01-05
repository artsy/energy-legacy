#import "ARLabSettingsSyncViewController.h"
#import "ARFlatButton.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "ARTopViewController.h"
#import "NSString+NiceAttributedStrings.h"
#import "ARSyncStatusViewModel.h"
#import "UIViewController+SettingsNavigationItemHelpers.h"
#import "ARSettingsNavigationBar.h"
#import "ARProgressView.h"
#import "KVOController/FBKVOController.h"


@interface ARLabSettingsSyncViewController ()
@property (nonatomic, strong) ARSyncStatusViewModel *viewModel;
@property (nonatomic, strong) FBKVOController *kvoController;

@property (weak, nonatomic) IBOutlet ARSyncFlatButton *syncButton;
@property (weak, nonatomic) IBOutlet UILabel *explanatoryTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousSyncsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ARProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *syncProgressLabel;

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
    [self setupSyncObserver];
    [self setupProgressView];

    [self.syncButton setTitle:@"Sync Content".uppercaseString forState:UIControlStateNormal];
    [self.syncButton setBackgroundColor:UIColor.artsyHeavyGrey forState:UIControlStateDisabled];

    NSString *string = self.explanatoryTextLabel.text;
    self.explanatoryTextLabel.attributedText = [string attributedStringWithLineSpacing:7.0];

    NSString *previousSyncsText = self.viewModel.syncLogCount ? @"Previous Syncs" : @"You have no previous syncs";
    [self.previousSyncsLabel setAttributedText:[previousSyncsText.uppercaseString attributedStringWithKern:1.3]];

    self.syncButton.hidden = !self.viewModel.shouldShowSyncButton;

    [self update];
}

- (void)setupSyncObserver
{
    [self.KVOController observe:self.viewModel keyPaths:@[ @"isActivelySyncing", @"networkQuality" ] options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [self update];
    }];

    [self.KVOController observe:self.viewModel keyPath:@"currentSyncPercentDone" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [self updateProgressView];
    }];
}


#pragma mark -
#pragma mark previous syncs tableview

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
    if (self.viewModel.previousSyncDateStrings) {
        cell.textLabel.text = self.viewModel.previousSyncDateStrings[indexPath.row];
        cell.textLabel.font = [UIFont serifFontWithSize:15];
        cell.textLabel.textColor = UIColor.artsyHeavyGrey;
    }
}

#pragma mark -
#pragma mark sync button

- (void)update
{
    if (self.viewModel.isActivelySyncing) {
        if (!self.progressView.alpha) [self showProgressView];
    } else {
        [self hideProgressView];
        [self configureSyncButton];
    }
}

- (void)configureSyncButton
{
    [self.syncButton setTitle:self.viewModel.syncButtonTitle forState:UIControlStateNormal];

    BOOL enableSyncButton = self.viewModel.shouldEnableSyncButton;
    self.syncButton.alpha = enableSyncButton ? 1 : 0.5;
    self.syncButton.enabled = enableSyncButton;
}

- (void)setupProgressView
{
    self.progressView.innerColor = UIColor.blackColor;
    self.progressView.outerColor = UIColor.blackColor;
    self.progressView.emptyColor = UIColor.whiteColor;
    self.progressView.progress = 0.0;
}

- (IBAction)syncButtonPressed:(id)sender
{
    [self.viewModel startSync];
    [self update];
}

- (void)showProgressView
{
    if (self.progressView.alpha) return;

    self.syncProgressLabel.text = self.viewModel.syncInProgressTitle;

    [UIView animateWithDuration:ARAnimationQuickDuration animations:^{
        self.syncButton.alpha = 0;
        self.progressView.alpha = 1;
        self.syncProgressLabel.alpha = 1;
    } completion:^(BOOL finished) {
        self.syncButton.hidden = YES;
    }];
}

- (void)updateProgressView
{
    CGFloat currentProgress = self.viewModel.currentSyncPercentDone;
    self.progressView.progress = currentProgress;
    self.syncProgressLabel.text = self.viewModel.syncInProgressTitle;
    if (currentProgress == 1) {
        [self hideProgressView];
        [self.tableView reloadData];
    }
}

- (void)hideProgressView
{
    if (!self.progressView.alpha) return;

    [UIView animateWithDuration:ARAnimationDuration animations:^{
        self.progressView.alpha = 0;
        self.syncProgressLabel.alpha = 0;
        self.syncButton.alpha = 1;
    } completion:^(BOOL finished) {
        self.syncButton.hidden = NO;
    }];
}

- (NSAttributedString *)expandedKernTextForString:(NSString *)string
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSKernAttributeName value:@(1.3) range:NSMakeRange(0, string.length)];
    return attrString;
}

#pragma mark -
#pragma mark navigation

- (void)setupNavigationBar
{
    if ([UIDevice isPhone]) [self addSettingsBackButtonWithTarget:@selector(returnToMasterViewController) animated:YES];
}

- (void)returnToMasterViewController
{
    [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark dependency injection

- (ARSyncStatusViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ARSyncStatusViewModel alloc] initWithSync:ARTopViewController.sharedInstance.sync context:CoreDataManager.mainManagedObjectContext];
    }
    return _viewModel;
}

@end

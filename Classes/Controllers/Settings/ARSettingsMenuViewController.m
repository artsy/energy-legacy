#import "ARSettingsMenuViewController.h"
#import "ARSettingsSectionButton.h"
#import "ARToggleSwitch.h"
#import "ARStoryboardIdentifiers.h"
#import "ARSettingsSplitViewController.h"
#import "NSString+NiceAttributedStrings.h"
#import <Intercom/Intercom.h>

#import "UIViewController+SettingsNavigationItemHelpers.h"

typedef NS_ENUM(NSInteger, ARSettingsAlertViewButtonIndex) {
    ARSettingsAlertViewButtonIndexCancel,
    ARSettingsAlertViewButtonIndexLogout
};


@interface ARSettingsMenuViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *settingsIcon;
@property (weak, nonatomic) IBOutlet UILabel *presentationModeLabel;

@property (weak, nonatomic) IBOutlet ARSettingsSectionButton *syncContentButton;
@property (weak, nonatomic) IBOutlet ARSettingsSectionButton *presentationModeButton;
@property (weak, nonatomic) IBOutlet ARToggleSwitch *presentationModeToggle;
@property (weak, nonatomic) IBOutlet ARSettingsSectionButton *editPresentationModeButton;

@property (weak, nonatomic) IBOutlet ARSettingsSectionButton *backgroundButton;
@property (weak, nonatomic) IBOutlet ARSettingsSectionButton *emailButton;
@property (weak, nonatomic) IBOutlet ARSettingsSectionButton *supportButton;
@property (weak, nonatomic) IBOutlet ARSettingsSectionButton *logoutButton;
@end


@implementation ARSettingsMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _viewModel = _viewModel ?: [[ARSettingsMenuViewModel alloc] init];

    [self setupNavigationBar];
    [self registerForNotifications];
    [self.viewModel initializePresentationMode];

    [self setupSectionButtons];
    [self.presentationModeLabel setAttributedText:[self.viewModel.presentationModeExplanatoryText attributedStringWithLineSpacing:5]];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsChanged) name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)setupNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    if ([UIDevice isPhone]) {
        [self addTitleViewWithText:@"Settings".uppercaseString font:[UIFont sansSerifFontWithSize:17] xOffset:0];
    }

    [self addSettingsExitButtonWithTarget:@selector(exitSettingsPanel) animated:YES];
}

- (void)setupSectionButtons
{
    /// Sync settings
    [self.syncContentButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARSettingsSectionSync]];
    [self.syncContentButton showAlertBadge:self.viewModel.shouldShowSyncNotification];

    /// Presentation mode settings
    [self setupPresentationModeButton];
    [self.editPresentationModeButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARSettingsSectionEditPresentationMode]];
    [self.editPresentationModeButton hideTopBorder];

    /// Miscellaneous settings
    [self.backgroundButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARSettingsSectionBackground]];
    [self.emailButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARSettingsSectionEmail]];
    [self.emailButton hideTopBorder];

    /// Intercom
    [self.supportButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARSettingsSectionSupport]];
    [self.supportButton hideChevron];

    /// Logout
    [self.logoutButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARSettingsSectionLogout]];
    [self.logoutButton hideChevron];
}

- (void)setupPresentationModeButton
{
    self.presentationModeToggle.on = [self.viewModel presentationModeOn];
    [self.presentationModeButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARSettingsSectionPresentationMode]];
    [self.presentationModeButton hideChevron];
    [self enablePresentationModeToggle:self.viewModel.shouldEnablePresentationMode];
}

- (void)defaultsChanged
{
    /// Check if presentation mode should be enabled
    [self enablePresentationModeToggle:self.viewModel.shouldEnablePresentationMode];
    self.presentationModeLabel.attributedText = [self.viewModel.presentationModeExplanatoryText attributedStringWithLineSpacing:5];

    /// Check for sync completion
    [self.syncContentButton showAlertBadge:self.viewModel.shouldShowSyncNotification];
}

- (void)enablePresentationModeToggle:(BOOL)enable
{
    self.presentationModeToggle.enabled = enable;
    [self.presentationModeButton setTitleTextColor:enable ? UIColor.blackColor : UIColor.artsyGrayBold];

    if (self.presentationModeToggle.on && !enable) {
        self.presentationModeToggle.on = NO;
        [self.viewModel disablePresentationMode];
    }
}

#pragma mark -
#pragma mark buttons

- (IBAction)syncButtonPressed:(id)sender
{
    [(ARSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARSettingsSectionSync];
}

- (IBAction)presentationModeButtonPressed:(id)sender
{
    if (!self.presentationModeToggle.isEnabled) {
        return;
    }

    [self.viewModel togglePresentationMode];
    self.presentationModeToggle.on = [self.viewModel presentationModeOn];
    [[NSNotificationCenter defaultCenter] postNotificationName:ARUserDidChangeGridFilteringSettingsNotification object:nil];
}

- (IBAction)editPresentationModeButtonPressed:(id)sender
{
    [(ARSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARSettingsSectionEditPresentationMode];
}
- (IBAction)backgroundButtonPressed:(id)sender
{
    [(ARSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARSettingsSectionBackground];
}

- (IBAction)emailButtonPressed:(id)sender
{
    [(ARSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARSettingsSectionEmail];
}

- (IBAction)supportButtonPressed:(id)sender
{
    [Intercom presentMessageComposer];
    [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];
}

- (IBAction)logoutButtonPressed:(id)sender
{
    [self showLogoutAlertView];
}

- (void)showLogoutAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"Do you want to logout?", @"Confirm Logout Prompt")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No", @"Cancel Logout Process")
                                          otherButtonTitles:NSLocalizedString(@"Yes, logout", @"Confirm Logout"), nil];
    [alert show];
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == ARSettingsAlertViewButtonIndexLogout) {
        [self exitSettingsPanel];
        [self.viewModel logout];
    }
}

#pragma mark -
#pragma mark exit strategies

- (void)exitSettingsPanel
{
    [(ARSettingsSplitViewController *)self.splitViewController exitSettingsPanel];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

#import "ARLabSettingsMasterViewController.h"
#import "ARLabSettingsSectionButton.h"
#import "ARToggleSwitch.h"
#import "ARStoryboardIdentifiers.h"
#import "ARLabSettingsSplitViewController.h"
#import "NSString+NiceAttributedStrings.h"
#import <Intercom/Intercom.h>
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "UIViewController+SettingsNavigationItemHelpers.h"
#import <EDColor/EDColor.h>


typedef NS_ENUM(NSInteger, ARSettingsAlertViewButtonIndex) {
    ARSettingsAlertViewButtonIndexCancel,
    ARSettingsAlertViewButtonIndexLogout
};


@interface ARLabSettingsMasterViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *settingsIcon;
@property (weak, nonatomic) IBOutlet UILabel *presentationModeLabel;

@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *syncContentButton;
@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *presentationModeButton;
@property (weak, nonatomic) IBOutlet ARToggleSwitch *presentationModeToggle;
@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *editPresentationModeButton;

@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *backgroundButton;
@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *emailButton;
@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *supportButton;
@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *logoutButton;
@end


@implementation ARLabSettingsMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _viewModel = _viewModel ?: [[ARLabSettingsMenuViewModel alloc] init];

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
    [self.syncContentButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionSync]];

    /// Presentation mode settings
    [self setupPresentationModeButton];
    [self.editPresentationModeButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionEditPresentationMode]];
    [self.editPresentationModeButton hideTopBorder];

    /// Miscellaneous settings
    [self.backgroundButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionBackground]];
    [self.emailButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionEmail]];
    [self.emailButton hideTopBorder];

    /// Intercom
    [self.supportButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionSupport]];
    [self.supportButton hideChevron];

    /// Logout
    [self.logoutButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionLogout]];
    [self.logoutButton hideChevron];
}

- (void)setupPresentationModeButton
{
    self.presentationModeToggle.on = [self.viewModel presentationModeOn];
    [self.presentationModeButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionPresentationMode]];
    [self.presentationModeButton hideChevron];
    [self enablePresentationModeToggle:self.viewModel.shouldEnablePresentationMode];
}

- (void)defaultsChanged
{
    [self enablePresentationModeToggle:self.viewModel.shouldEnablePresentationMode];
    self.presentationModeLabel.attributedText = [self.viewModel.presentationModeExplanatoryText attributedStringWithLineSpacing:5];
}

- (void)enablePresentationModeToggle:(BOOL)enable
{
    self.presentationModeToggle.enabled = enable;
    [self.presentationModeButton setTitleTextColor:enable ? UIColor.blackColor : UIColor.artsyHeavyGrey];

    if (self.presentationModeToggle.on && !enable) {
        self.presentationModeToggle.on = NO;
        [self.viewModel disablePresentationMode];
    }
}

#pragma mark -
#pragma mark buttons

- (IBAction)syncButtonPressed:(id)sender
{
    [(ARLabSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARLabSettingsSectionSync];
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
    [(ARLabSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARLabSettingsSectionEditPresentationMode];
}
- (IBAction)backgroundButtonPressed:(id)sender
{
    [(ARLabSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARLabSettingsSectionBackground];
}

- (IBAction)emailButtonPressed:(id)sender
{
    [(ARLabSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARLabSettingsSectionEmail];
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
    [(ARLabSettingsSplitViewController *)self.splitViewController exitSettingsPanel];
}

- (IBAction)ogSettingsButtonPressed:(id)sender
{
    [self.viewModel switchToOriginalSettings];
    [self exitSettingsPanel];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

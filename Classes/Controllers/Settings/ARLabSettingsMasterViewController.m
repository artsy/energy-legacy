#import "ARLabSettingsMasterViewController.h"
#import "ARLabSettingsSectionButton.h"
#import "ARToggleSwitch.h"
#import "ARStoryboardIdentifiers.h"
#import "ARLabSettingsSplitViewController.h"
#import "ARLabSettingsNavigationController.h"
#import "NSString+NiceAttributedStrings.h"
#import "ARLabSettingsMenuViewModel.h"

typedef NS_ENUM(NSInteger, ARSettingsAlertViewButtonIndex) {
    ARSettingsAlertViewButtonIndexCancel,
    ARSettingsAlertViewButtonIndexLogout
};


@interface ARLabSettingsMasterViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) ARLabSettingsMenuViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIButton *settingsIcon;
@property (weak, nonatomic) IBOutlet UILabel *presentationModeLabel;

@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *syncContentButton;
@property (weak, nonatomic) IBOutlet ARLabSettingsSectionButton *presentationModeButton;
@property (weak, nonatomic) IBOutlet UIView *presentationModeToggle;
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

    [self setupSettingsIcon];
    [self setupSectionButtons];
    [self.presentationModeLabel setAttributedText:self.viewModel.presentationModeExplanatoryText];
}

- (void)setupSectionButtons
{
    /// Sync settings
    [self.syncContentButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionSync]];

    /// Presentation Mode settings
    [self.presentationModeButton setTitle:[self.viewModel buttonTitleForSettingsSection:ARLabSettingsSectionPresentationMode]];
    [self.presentationModeButton hideChevron];
    [self setupPresentationModeToggleSwitch];

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

- (void)setupPresentationModeToggleSwitch
{
    ARToggleSwitch *toggle = [ARToggleSwitch buttonWithFrame:self.presentationModeToggle.frame];
    toggle.userInteractionEnabled = NO;
    [self.presentationModeButton addSubview:toggle];
    toggle.on = [self.viewModel presentationModeOn];
}

#pragma mark -
#pragma mark buttons

- (IBAction)syncButtonPressed:(id)sender
{
    [(ARLabSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARLabSettingsSectionSync];
}

- (IBAction)presentationModeButtonPressed:(id)sender
{
    ARToggleSwitch *toggle = [self.presentationModeButton.subviews find:^BOOL(UIView *subview) {
        return [subview isKindOfClass:ARToggleSwitch.class];
    }];
    if (toggle) {
        [self.viewModel togglePresentationMode];
        toggle.on = [self.viewModel presentationModeOn];
    }
}

- (IBAction)editPresentationModeButtonPressed:(id)sender
{
    [(ARLabSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARLabSettingsSectionPresentationMode];
}

- (IBAction)emailButtonPressed:(id)sender
{
    [(ARLabSettingsSplitViewController *)self.splitViewController showDetailViewControllerForSettingsSection:ARLabSettingsSectionEmail];
}

- (IBAction)logoutButtonPressed:(id)sender
{
    [self showLogoutAlertView];
}

- (void)showLogoutAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:self.viewModel.logoutPrompt
                                                   delegate:self
                                          cancelButtonTitle:self.viewModel.cancelLogoutButtonText
                                          otherButtonTitles:self.viewModel.confirmLogoutText, nil];
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
#pragma mark settings icon

- (void)setupSettingsIcon
{
    [self.settingsIcon setImage:self.viewModel.settingsButtonImage forState:UIControlStateNormal];
    [self.settingsIcon setTintColor:UIColor.blackColor];
    [self.settingsIcon setBackgroundColor:UIColor.whiteColor];
}

- (IBAction)settingsIconPressed:(id)sender
{
    [self exitSettingsPanel];
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

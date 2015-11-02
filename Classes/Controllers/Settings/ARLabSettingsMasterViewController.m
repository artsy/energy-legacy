#import "ARLabSettingsMasterViewController.h"
#import "AROptions.h"
#import "ARLabSettingsSectionButton.h"
#import "ARToggleSwitch.h"
#import "ARStoryboardIdentifiers.h"
#import "ARLabSettingsSplitViewController.h"
#import "ARLabSettingsDetailViewManager.h"


@interface ARLabSettingsMasterViewController ()
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

@property (assign) BOOL presentationMode;

@end


@implementation ARLabSettingsMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSettingsIcon];
    [self setupSectionButtons];
    self.presentationMode = NO;
    [self setPresentationModeLabelText:NSLocalizedString(@"Hides sensitive information when showing artworks to clients", @"Explanatory text for presentation mode setting")];
}

- (void)setupSectionButtons
{
    /// Sync settings
    [self.syncContentButton setTitle:NSLocalizedString(@"Sync Content", @"Title for sync settings button")];

    /// Presentation Mode settings
    [self.presentationModeButton setTitle:NSLocalizedString(@"Presentation Mode", @"Title for presentation mode toggle button")];
    [self.presentationModeButton hideChevron];
    [self setupPresentationModeToggleSwitch];

    [self.editPresentationModeButton setTitle:NSLocalizedString(@"Edit Presentation Mode", @"Title for edit presentation mode settings button")];
    [self.editPresentationModeButton hideTopBorder];

    /// Miscellaneous settings
    [self.backgroundButton setTitle:NSLocalizedString(@"Background", @"Title for background settings button")];
    [self.emailButton setTitle:NSLocalizedString(@"Email", @"Title for email settings button")];
    [self.emailButton hideTopBorder];

    /// Intercom
    [self.supportButton setTitle:NSLocalizedString(@"Support", @"Title for support button")];
    [self.supportButton hideChevron];

    /// Logout
    [self.logoutButton setTitle:NSLocalizedString(@"Logout", @"Title for logout button")];
    [self.logoutButton hideChevron];
}

- (void)setupPresentationModeToggleSwitch
{
    ARToggleSwitch *toggle = [ARToggleSwitch buttonWithFrame:self.presentationModeToggle.frame];
    toggle.userInteractionEnabled = NO;
    [self.presentationModeButton addSubview:toggle];
    toggle.on = self.presentationMode;
}

#pragma mark -
#pragma mark labels

- (void)setPresentationModeLabelText:(NSString *)string
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [self.presentationModeLabel setAttributedText:attrString];
}

- (IBAction)presentationModeButtonPressed:(id)sender
{
    ARToggleSwitch *toggle = [self.presentationModeButton.subviews find:^BOOL(UIView *subview) {
        return [subview isKindOfClass:ARToggleSwitch.class];
    }];
    if (toggle) {
        toggle.on = !self.presentationMode;
        self.presentationMode = !self.presentationMode;
    }
}

#pragma mark -
#pragma mark settings icon

- (void)setupSettingsIcon
{
    [self.settingsIcon setImage:[[UIImage imageNamed:@"settings_btn_whiteborder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
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
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AROptionsUseLabSettings];
    [self exitSettingsPanel];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

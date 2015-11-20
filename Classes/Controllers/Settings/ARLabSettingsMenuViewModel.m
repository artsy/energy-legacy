#import "ARLabSettingsMenuViewModel.h"
#import "ARAppDelegate.h"
#import "AROptions.h"


@interface ARLabSettingsMenuViewModel ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) ARAppDelegate *appDelegate;
@end


@implementation ARLabSettingsMenuViewModel

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults appDelegate:(ARAppDelegate *)appDelegate
{
    self = [super init];
    if (!self) return nil;
    
    _defaults = defaults;
    _appDelegate = appDelegate;
    
    return self;
}

- (NSString *)buttonTitleForSettingsSection:(ARLabSettingsSection)section
{
    switch (section) {
        case ARLabSettingsSectionSync:
            return NSLocalizedString(@"Sync Content", @"Title for sync settings button");
        case ARLabSettingsSectionPresentationMode:
            return NSLocalizedString(@"Presentation Mode", @"Title for presentation mode toggle button");
        case ARLabSettingsSectionEditPresentationMode:
            return NSLocalizedString(@"Edit Presentation Mode", @"Title for edit presentation mode settings button");
        case ARLabSettingsSectionBackground:
            return NSLocalizedString(@"Background", @"Title for background settings button");
        case ARLabSettingsSectionEmail:
            return NSLocalizedString(@"Email", @"Title for email settings button");
        case ARLabSettingsSectionSupport:
            return NSLocalizedString(@"Support", @"Title for support button");
        case ARLabSettingsSectionLogout:
            return NSLocalizedString(@"Logout", @"Title for logout button");
        default:
            break;
    }
}

- (BOOL)presentationModeOn
{
    return [self.defaults boolForKey:ARPresentationModeOn];
}
//
- (void)togglePresentationMode
{
    BOOL on = ![self presentationModeOn];
    [self.defaults setBool:on forKey:ARPresentationModeOn];
}
//
- (NSString *)logoutPrompt
{
    return NSLocalizedString(@"Do you want to logout?", @"Confirm Logout Prompt");
}
//
- (NSString *)cancelLogoutButtonText
{
    return NSLocalizedString(@"No", @"Cancel Logout Process");
}
//
- (NSString *)confirmLogoutText
{
    return NSLocalizedString(@"Yes, logout", @"Confirm Logout");
}
//
- (UIImage *)settingsButtonImage
{
    return [[UIImage imageNamed:@"settings_btn_whiteborder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
//
- (void)logout
{
    [self.appDelegate startLogout];
    [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];
}

- (void)switchToOriginalSettings
{
    [self.defaults setBool:NO forKey:AROptionsUseLabSettings];
}

#pragma mark -
#pragma mark dependency injection

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

- (ARAppDelegate *)appDelegate
{
    return _appDelegate ?: (ARAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end

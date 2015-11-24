#import "ARAppDelegate.h"
#import "ARLabSettingsSplitViewController.h"


@interface ARLabSettingsMenuViewModel : NSObject

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults appDelegate:(ARAppDelegate *)appDelegate;

- (NSString *)buttonTitleForSettingsSection:(ARLabSettingsSection)section;

- (NSAttributedString *)presentationModeExplanatoryText;

- (BOOL)presentationModeOn;

- (void)togglePresentationMode;

- (NSString *)logoutPrompt;

- (NSString *)cancelLogoutButtonText;

- (NSString *)confirmLogoutText;

- (UIImage *)settingsButtonImage;

- (void)logout;

- (void)switchToOriginalSettings;


@end

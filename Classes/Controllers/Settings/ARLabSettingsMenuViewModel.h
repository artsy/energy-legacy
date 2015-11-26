#import "ARAppDelegate.h"
#import "ARLabSettingsSplitViewController.h"


@interface ARLabSettingsMenuViewModel : NSObject

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults appDelegate:(ARAppDelegate *)appDelegate;

- (NSString *)buttonTitleForSettingsSection:(ARLabSettingsSection)section;

- (NSString *)presentationModeExplanatoryText;

- (BOOL)presentationModeOn;

- (void)togglePresentationMode;

- (UIImage *)settingsButtonImage;

- (void)logout;

- (void)switchToOriginalSettings;


@end

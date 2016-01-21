#import "ARAppDelegate.h"
#import "ARLabSettingsSplitViewController.h"


@interface ARLabSettingsMenuViewModel : NSObject

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults context:(NSManagedObjectContext *)context appDelegate:(ARAppDelegate *)appDelegate;

- (NSString *)buttonTitleForSettingsSection:(ARLabSettingsSection)section;

- (void)initializePresentationMode;

- (NSString *)presentationModeExplanatoryText;

- (BOOL)presentationModeOn;

- (void)togglePresentationMode;
- (void)disablePresentationMode;

- (BOOL)shouldEnablePresentationMode;

- (UIImage *)settingsButtonImage;

- (void)logout;

- (void)switchToOriginalSettings;


@end

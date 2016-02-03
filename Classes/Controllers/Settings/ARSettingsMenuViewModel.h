#import "ARAppDelegate.h"
#import "ARSettingsSplitViewController.h"


@interface ARSettingsMenuViewModel : NSObject

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults context:(NSManagedObjectContext *)context appDelegate:(ARAppDelegate *)appDelegate;

/// Copy methods
- (NSString *)buttonTitleForSettingsSection:(ARSettingsSection)section;
- (NSString *)presentationModeExplanatoryText;

/// Returns YES if we're recommending a sync
- (BOOL)shouldShowSyncNotification;

/// Initialization, enabling, toggling, and disabling of presentation mode
- (void)initializePresentationMode;
- (BOOL)presentationModeOn;
- (BOOL)shouldEnablePresentationMode;
- (void)togglePresentationMode;
- (void)disablePresentationMode;

/// Returns either a settings cog or 'x' depending on device
- (UIImage *)settingsButtonImage;

/// Logs out via ARAppDelegate
- (void)logout;

/// Deprecated once old settings are removed
- (void)switchToOriginalSettings;

@end

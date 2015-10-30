typedef NS_ENUM(NSInteger, ARLabSettingsSection) {
    ARLabSettingsSectionSync,
    ARLabSettingsSectionPresentationMode,
    ARLabSettingsSectionBackground,
    ARLabSettingsSectionEmail,
};

@protocol SettingsSectionViewController

@end

@interface ARLabSettingsDetailViewManager : NSObject <UISplitViewControllerDelegate>

- (id)viewModelForSection:(ARLabSettingsSection)section;

@end

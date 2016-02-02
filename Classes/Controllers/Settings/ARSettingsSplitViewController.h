typedef NS_ENUM(NSInteger, ARSettingsSection) {
    ARSettingsSectionSync,
    ARSettingsSectionPresentationMode,
    ARSettingsSectionEditPresentationMode,
    ARSettingsSectionBackground,
    ARSettingsSectionEmail,
    ARSettingsSectionSupport,
    ARSettingsSectionLogout,
};

@protocol ARSettingsDetailViewController
@required
@property (nonatomic, assign) ARSettingsSection section;
@end


@interface ARSettingsSplitViewController : UISplitViewController <UISplitViewControllerDelegate>

- (void)exitSettingsPanel;

- (void)showDetailViewControllerForSettingsSection:(ARSettingsSection)section;

@end

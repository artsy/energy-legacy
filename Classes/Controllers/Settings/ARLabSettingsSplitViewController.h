typedef NS_ENUM(NSInteger, ARLabSettingsSection) {
    ARLabSettingsSectionSync,
    ARLabSettingsSectionPresentationMode,
    ARLabSettingsSectionEditPresentationMode,
    ARLabSettingsSectionBackground,
    ARLabSettingsSectionEmail,
    ARLabSettingsSectionSupport,
    ARLabSettingsSectionLogout,
};

@protocol ARLabSettingsDetailViewController
@required
@property (nonatomic, assign) ARLabSettingsSection section;
@end


@interface ARLabSettingsSplitViewController : UISplitViewController <UISplitViewControllerDelegate>

- (void)exitSettingsPanel;

- (void)showDetailViewControllerForSettingsSection:(ARLabSettingsSection)section;

@end

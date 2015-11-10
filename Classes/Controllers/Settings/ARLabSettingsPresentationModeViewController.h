


@interface ARLabSettingsPresentationModeViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSUserDefaults *defaults;

+ (BOOL)shouldShowPresentationModeSettingsWithContext:(NSManagedObjectContext *)context;

@end

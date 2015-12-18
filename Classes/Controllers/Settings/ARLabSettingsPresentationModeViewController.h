#import "ARLabSettingsSplitViewController.h"


@interface ARLabSettingsPresentationModeViewController : UITableViewController <ARLabSettingsDetailViewController, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

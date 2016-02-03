#import "ARSettingsSplitViewController.h"


@interface ARPresentationModeSettingsViewController : UITableViewController <ARSettingsDetailViewController, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

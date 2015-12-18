#import "ARLabSettingsSplitViewController.h"


@interface ARLabSettingsBackgroundViewController : UITableViewController <ARLabSettingsDetailViewController, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

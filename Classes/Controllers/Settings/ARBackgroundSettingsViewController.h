#import "ARSettingsSplitViewController.h"


@interface ARBackgroundSettingsViewController : UITableViewController <ARSettingsDetailViewController, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

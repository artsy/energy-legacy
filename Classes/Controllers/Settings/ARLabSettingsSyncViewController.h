#import "ARSyncStatusViewModel.h"
#import "ARLabSettingsSplitViewController.h"


@interface ARLabSettingsSyncViewController : UIViewController <ARLabSettingsDetailViewController, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) ARSyncStatusViewModel *viewModel;

@end

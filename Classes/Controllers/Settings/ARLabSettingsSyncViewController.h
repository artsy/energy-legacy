#import "ARLabSettingsSplitViewController.h"

@class ARSyncStatusViewModel, ARNetworkQualityIndicator;


@interface ARLabSettingsSyncViewController : UIViewController <ARLabSettingsDetailViewController, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) ARSyncStatusViewModel *viewModel;
@property (nonatomic, strong) ARNetworkQualityIndicator *qualityIndicator;

@end

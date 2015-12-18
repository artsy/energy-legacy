#import "ARLabSettingsSplitViewController.h"

@class ARNetworkQualityIndicator;


@interface ARLabSettingsSyncViewController : UIViewController <ARLabSettingsDetailViewController, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) ARNetworkQualityIndicator *qualityIndicator;

@end

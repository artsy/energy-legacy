#import "ARSettingsBaseViewController.h"
#import "ARSync.h"
#import "ARSyncStatusViewModel.h"


@interface ARSettingsViewController : ARSettingsBaseViewController


- (IBAction)sync:(id)sender;

@property (nonatomic, strong) ARSync *sync;

@end

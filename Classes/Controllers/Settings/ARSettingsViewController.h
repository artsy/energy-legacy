#import "ARSettingsBaseViewController.h"
#import "ARSync.h"


@interface ARSettingsViewController : ARSettingsBaseViewController <ARSyncDelegate, ARSyncProgressDelegate>

- (IBAction)sync:(id)sender;

@property (nonatomic, strong) ARSync *sync;

@end

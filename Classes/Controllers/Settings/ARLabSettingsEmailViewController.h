#import "ARLabSettingsEmailViewModel.h"
#import "ARLabSettingsSplitViewController.h"


@interface ARLabSettingsEmailViewController : UIViewController <ARLabSettingsDetailViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ARLabSettingsEmailViewModel *viewModel;

@end

#import "AREmailSettingsViewModel.h"
#import "ARSettingsSplitViewController.h"


@interface AREmailSettingsViewController : UIViewController <ARSettingsDetailViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AREmailSettingsViewModel *viewModel;

@end

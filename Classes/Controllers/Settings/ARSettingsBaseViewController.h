#import <UIKit/UIKit.h>

extern NSString *SettingsCellReuse;


@interface ARSettingsBaseViewController : UIViewController <UITableViewDataSource, UITableViewDataSource> {
    NSArray *sectionHeaders;
}

@property (nonatomic, assign) IBOutlet UITableView *tableView;

@end

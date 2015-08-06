

@interface AREditAlbumViewController : UIViewController

- (instancetype)initWithAlbum:(Album *)album;
@property (nonatomic, strong, readonly) Album *album;

@property (readonly, nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign, readwrite) NSUserDefaults *defaults;

@end

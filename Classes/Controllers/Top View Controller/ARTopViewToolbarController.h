@class ARTopViewController;


@interface ARTopViewToolbarController : NSObject

- (instancetype)initWithTopVC:(ARTopViewController *)topViewController;

@property (nonatomic, weak, readonly) ARTopViewController *topViewController;
@property (nonatomic, strong, readonly) UIBarButtonItem *settingsPopoverItem;

- (void)setupDefaultToolbarItems;
- (void)hideSyncNotificationBadge;
- (void)showSyncNotificationBadge;

@end

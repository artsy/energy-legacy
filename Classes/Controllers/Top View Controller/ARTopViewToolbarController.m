#import "ARTopViewController.h"
#import "ARTopViewToolbarController.h"
#import "ARNavigationController.h"
#import "ARSync.h"
#import "UIView+ARImageBadge.h"


@implementation ARTopViewToolbarController

- (instancetype)initWithTopVC:(ARTopViewController *)topViewController
{
    self = [super init];
    if (!self) return nil;

    _topViewController = topViewController;

    [self registerForSettingsIconNotifications];

    return self;
}

- (ARNavigationController *)navigationController
{
    return (id)self.topViewController.navigationController;
}

- (UINavigationItem *)navigationItem
{
    return self.topViewController.navigationItem;
}

- (void)registerForSettingsIconNotifications
{
    [self observeNotification:ARSyncStartedNotification globallyWithSelector:@selector(updateSettingsButtonIcon)];
    [self observeNotification:ARSyncFinishedNotification globallyWithSelector:@selector(updateSettingsButtonIcon)];
}

- (void)updateSettingsButtonIcon
{
    if (self.topViewController.sync.isSyncing) {
        [self.settingsPopoverItem.representedButton setToolbarImagesWithName:@"Refresh"];
    } else {
        [self.settingsPopoverItem.representedButton setToolbarImagesWithName:@"Settings"];
    }
}

- (void)showSyncNotificationBadge
{
    if (!self.settingsPopoverItem.representedButton.badge) {
        [self addNotificationBadge:self.settingsPopoverItem.representedButton];
    } else {
        self.settingsPopoverItem.representedButton.badge.hidden = NO;
    }
}

- (void)addNotificationBadge:(UIButton *)button
{
    if ([UIDevice isPad]) {
        [button addBadgeWithImage:[UIImage imageNamed:@"alert-badge-large"] position:BottomLeft offset:6];
        [button.badge setSize:22 width:22];
    } else {
        [button addBadgeWithImage:[UIImage imageNamed:@"alert-badge-small"] position:BottomRight offset:0];
        [button.badge setSize:15 width:15];
    }
}

- (void)hideSyncNotificationBadge
{
    if (self.settingsPopoverItem.representedButton.badge) {
        self.settingsPopoverItem.representedButton.badge.hidden = YES;
        [self.settingsPopoverItem.representedButton.badge removeFromSuperview];
    }
}

- (void)setupDefaultToolbarItems
{
    NSMutableArray *items = [NSMutableArray array];

    UIBarButtonItem *search = self.navigationController.newSearchPopoverButton;
    if (search) [items addObject:search];

    if (!self.settingsPopoverItem) {
        _settingsPopoverItem = [UIBarButtonItem toolbarImageButtonWithName:@"settings" withTarget:self.topViewController andSelector:@selector(toggleSettingsPopover)];
    }

    BOOL showEditAlbums = (self.topViewController.displayMode == ARDisplayModeAllAlbums);
    if (showEditAlbums && [UIDevice isPad]) {
        UIBarButtonItem *createAlbumButton = [self editAlbumButton];
        [items addObject:createAlbumButton];
    }

    [self setToolbarItems:items settingsItem:self.settingsPopoverItem];
}

- (void)setToolbarItems:(NSArray *)items settingsItem:(UIBarButtonItem *)settingsItem
{
    if ([UIDevice isPad]) {
        self.navigationItem.leftBarButtonItem = settingsItem;
        self.navigationItem.rightBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItem = [items firstObject];
        NSArray *remainingItems = [items select:^BOOL(id object) {
            return [items indexOfObject:object] != 0;
        }];
        self.navigationItem.leftBarButtonItems = @[ settingsItem, remainingItems ].flatten;
    }
}

- (UIBarButtonItem *)editAlbumButton
{
    UIBarButtonItem *button = [UIBarButtonItem toolbarButtonWithTitle:@"Edit" target:self.topViewController action:@selector(toggleEditMode)];
    button.accessibilityLabel = @"Edit Albums";
    return button;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

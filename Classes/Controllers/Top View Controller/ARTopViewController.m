#import "ARTopViewToolbarController.h"
#import "ARUnderLinedSwitchView.h"
#import "ARTopViewController.h"
#import "ARSettingsViewController.h"
#import "ARTopViewController+EditingAlbum.h"
#import "ARBaseViewController+TransparentModals.h"
#import "ARSearchViewController.h"
#import "ARSwitchBoard.h"
#import "ARSyncMessageViewController.h"
#import "ARGridViewDataSource.h"
#import "ARImageGridViewItem.h"
#import "ARSettingsNavigationController.h"
#import "AROptions.h"
#import "ARLabSettingsSplitViewController.h"

NS_ENUM(NSInteger, ARTopViewControllers){
    ARTopViewControllerArtists = 0,
    ARTopViewControllerShows = 1,
    ARTopViewControllerLocations = 1,
    ARTopViewControllerAlbums = 2};


@interface ARTopViewController () <ARSyncMessageViewControllerDelegate>

@property (nonatomic, strong) ARTabContentView *tabView;
@property (nonatomic, strong) ARUnderLinedSwitchView *switchView;
@property (nonatomic, strong) ARPopoverController *settingsPopoverController;
@property (nonatomic, strong) ARTopViewToolbarController *toolbarController;
@property (nonatomic, assign) BOOL hasCheckedSyncStatus;
@property (nonatomic, strong) ARSwitchBoard *switchBoard;

@property (nonatomic, strong) NSLayoutConstraint *bottomToolbarHeightConstraint;

@property (nonatomic, assign, readonly) BOOL editing;
@property (nonatomic, assign) BOOL skipFadeIn;
@end


@implementation ARTopViewController

+ (ARTopViewController *)sharedInstance
{
    static ARTopViewController *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _toolbarController = [[ARTopViewToolbarController alloc] initWithTopVC:self];

    [self registerForAlbumEditNotifications];
    [self observeNotification:ARDismissAllPopoversNotification globallyWithSelector:@selector(dismissPopovers)];

    return self;
}


#pragma mark -
#pragma mark Fade in for App Launch

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self reloadCurrentViewController];
    [self setEditing:NO animated:NO];
    [self.toolbarController setupDefaultToolbarItems];

    if (!self.hasCheckedSyncStatus) {
        _cmsMonitor = _cmsMonitor ?: [[ARCMSStatusMonitor alloc] init];
        [self checkSyncStatus];
        _hasCheckedSyncStatus = YES;
    }

    [ARSearchViewController sharedController].selectedItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSwitchViewToNav];

    [self fadeInNavItems];
    [self fadeInSwitchView];

    _tabView = [self createTabView];
    [self.view addSubview:self.tabView];
    [self.tabView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];

    [self.tabView setCurrentViewIndex:0 animated:NO];
    [self setDisplayMode:ARDisplayModeAllArtists];

    _bottomToolbar = [self createBottomToolbar];
    [self.view addSubview:self.bottomToolbar];

    _bottomToolbarHeightConstraint = [[self.bottomToolbar constrainHeight:@"0"] firstObject];
    [self.bottomToolbar constrainTopSpaceToView:self.tabView predicate:@"0"];
    [self.bottomToolbar alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];

    [self.view setNeedsLayout];
}

- (void)fadeInNavItems
{
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.customView.alpha = 0.5;
    }

    [UIView animateIf:!self.skipFadeIn duration:ARAnimationDuration:^{
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.customView.alpha = 1;
        }
    }];
}

- (void)fadeInSwitchView
{
    [_switchView fadeInFromDisabledAnimated:!self.skipFadeIn];
}

#pragma mark -
#pragma mark Sync Notifications

- (void)checkSyncStatus
{
    if (![Partner currentPartnerInContext:self.managedObjectContext]) return;

    [self.cmsMonitor checkCMSForUpdates:^(BOOL updated) {
        if (updated) {
            [self.toolbarController showSyncNotificationBadge];
        }
    }];
}

#pragma mark -
#pragma mark Tab View Data Source Methods

- (UIViewController *)viewControllerForTabView:(ARTabContentView *)tabView atIndex:(NSInteger)index
{
    id controller = nil;

    switch (index) {
        case ARTopViewControllerArtists:
            _displayMode = ARDisplayModeAllArtists;
            self.title = @"All Artists";
            controller = [self createArtistView];
            break;

        case ARTopViewControllerShows:
            //      case ARTopViewControllerLocations:

            if ([self partnerIsGallery]) {
                _displayMode = ARDisplayModeAllShows;
                self.title = @"All Shows";
                controller = [self createShowView];
            } else {
                _displayMode = ARDisplayModeAllLocations;
                self.title = @"All Locations";
                controller = [self createLocationView];
            }
            break;


        case ARTopViewControllerAlbums:
            _displayMode = ARDisplayModeAllAlbums;
            self.title = @"All Albums";
            controller = [self createAlbumsView];
            break;
    }

    [self.toolbarController setupDefaultToolbarItems];

    BOOL showEditMenu = self.hasFinishedSync && (self.displayMode == ARDisplayModeAllAlbums) && ![UIDevice isPad];
    [self showBottomToolbar:showEditMenu animated:YES];

    if ([controller respondsToSelector:@selector(setManagedObjectContext:)]) {
        [controller setManagedObjectContext:self.managedObjectContext];
    }

    return controller;
}

- (BOOL)tabView:(ARTabContentView *)tabView canPresentViewControllerAtIndex:(NSInteger)index
{
    return YES;
}

- (BOOL)partnerIsGallery
{
    Partner *partner = [Partner currentPartnerInContext:self.managedObjectContext];
    switch (partner.type) {
        case ARPartnerTypeGallery:
            return YES;

        case ARPartnerTypeCollector:
            return NO;
    }
}

- (NSInteger)numberOfViewControllersForTabView:(ARTabContentView *)tabView
{
    return 3;
}

#pragma mark - Tab View Delegate Methods

- (void)tabView:(ARTabContentView *)tabView didChangeSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    [ARAnalytics pageView:[self pageID]];
}

#pragma mark - Grid View Creation Methods

- (UIViewController *)createArtistView
{
    return [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeAllArtists];
}

- (UIViewController *)createShowView
{
    NSString *shows = NSLocalizedString(@"Shows", @"Show collective noun");
    return [self createWaitingViewNamed:shows displayMode:ARDisplayModeAllShows class:Show.class];
}

- (UIViewController *)createLocationView
{
    NSString *locations = NSLocalizedString(@"Locations", @"Location  collective noun");
    return [self createWaitingViewNamed:locations displayMode:ARDisplayModeAllLocations class:Location.class];
}

- (UIViewController *)createWaitingViewNamed:(NSString *)type displayMode:(ARDisplayMode)mode class:(Class)klass
{
    if (!self.hasFinishedSync && !ARIsOSSBuild) {
        NSString *messageFormat = NSLocalizedString(@"Your %@ are Syncing", @"Your %@ are syncing message for showing progress");
        return [self syncMessageViewControllerWithMessage:[NSString stringWithFormat:messageFormat, type]];
    }

    if ([klass countInContext:self.managedObjectContext error:nil] == 0 && !ARIsOSSBuild) {
        NSString *messageFormat = NSLocalizedString(@"You have no %@ set up in CMS", @"You have no %@ in CMS message");
        return [self messageViewControllerWithMessage:[NSString stringWithFormat:messageFormat, type]];
    }

    return [[ARGridViewController alloc] initWithDisplayMode:mode];
}

/// Because of "All Artworks" there is always albums to show

- (UIViewController *)createAlbumsView
{
    if (!self.hasFinishedSync && !ARIsOSSBuild) {
        return [self syncMessageViewControllerWithMessage:@"Your Albums are Syncing"];
    } else {
        return [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeAllAlbums];
    }
}

- (BOOL)hasFinishedSync
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ARFinishedFirstSync];
}

- (UIViewController *)syncMessageViewControllerWithMessage:(NSString *)message
{
    ARSyncMessageViewController *messageVC = [[ARSyncMessageViewController alloc] initWithMessage:message sync:self.sync];
    messageVC.delegate = self;
    return messageVC;
}

- (UIViewController *)messageViewControllerWithMessage:(NSString *)message
{
    return [[ARSyncMessageViewController alloc] initWithMessage:message sync:nil];
}

- (void)syncViewControllerDidFinish:(ARSyncMessageViewController *)controller
{
    [self.tabView setCurrentViewIndex:self.tabView.currentViewIndex animated:NO];
}

- (ARTabContentView *)createTabView
{
    ARTabContentView *tabView = [[ARTabContentView alloc] initWithFrame:self.view.bounds hostViewController:self delegate:self dataSource:self];
    tabView.switchView = _switchView;

    return tabView;
}

- (ARSelectionToolbarView *)createBottomToolbar
{
    ARSelectionToolbarView *bottomToolbar = [[ARSelectionToolbarView alloc] initWithFrame:CGRectZero];
    bottomToolbar.horizontallyConstrained = ![UIDevice isPad];
    bottomToolbar.attatchedToBottom = YES;

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditMode)];
    bottomToolbar.barButtonItems = @[ item ];

    if ([UIDevice isPad]) {
        [bottomToolbar.button setHidden:YES];
    }

    return bottomToolbar;
}

#pragma mark -
#pragma mark Popover

- (void)toggleSettingsPopover
{
    [self toggleSettingsPopoverAnimated:YES];
}

- (void)toggleSettingsPopoverAnimated:(BOOL)animated

{
    if (self.settingsPopoverController.isPopoverVisible) {
        [self dismissPopoversAnimated:animated];

    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:AROptionsUseLabSettings] && [[User currentUser] isAdmin]) {

        UIStoryboard *labSettings = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
        UIViewController *labSettingsViewController = [labSettings instantiateInitialViewController];

        labSettingsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:labSettingsViewController animated:YES completion:nil];
    } else {
        [self dismissPopoversAnimated:animated];
        [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];

        ARSettingsViewController *settingsViewController = [[ARSettingsViewController alloc] init];
        [settingsViewController setSync:self.sync];

        ARSettingsNavigationController *navController = [[NSBundle mainBundle] loadNibNamed:@"ARSettingsNavigationController" owner:self options:nil][0];
        navController.viewControllers = @[ settingsViewController ];

        UIButton *settingsButton = self.toolbarController.settingsPopoverItem.representedButton;
        settingsButton.selected = YES;

        [self.toolbarController hideSyncNotificationBadge];

        _settingsPopoverController = [[ARPopoverController alloc] initWithContentViewController:navController];

        NSMutableArray *buttons = [NSMutableArray array];
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            [buttons addObject:item.customView];
        }

        self.settingsPopoverController.passthroughViews = buttons;
        self.settingsPopoverController.delegate = self;
        navController.hostPopoverController = self.settingsPopoverController;

        CGRect buttonFrame = [self.view convertRect:settingsButton.frame fromView:[settingsButton superview]];
        [self.settingsPopoverController presentPopoverFromRect:buttonFrame
                                                        inView:self.view
                                      permittedArrowDirections:WYPopoverArrowDirectionUp
                                                      animated:animated];
    }
}

#pragma mark -
#pragma mark Popovers

- (void)dismissPopovers
{
    [self dismissPopoversAnimated:NO];
}

- (void)dismissPopoversAnimated:(BOOL)animate
{
    [self.settingsPopoverController dismissPopoverAnimated:animate];
    [self popoverControllerDidDismissPopover:self.settingsPopoverController];
}

- (void)popoverControllerDidDismissPopover:(ARPopoverController *)aPopoverController
{
    if (aPopoverController == self.settingsPopoverController) {
        self.toolbarController.settingsPopoverItem.representedButton.selected = NO;
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(ARPopoverController *)popoverController
{
    return YES;
}

#pragma mark -
#pragma mark Switch View

- (void)addSwitchViewToNav
{
    if ([self.navigationItem.titleView class] == [ARUnderLinedSwitchView class]) return;

    CGFloat width;
    if ([UIDevice isPad]) {
        width = [self partnerIsGallery] ? 300 : 340;
    } else {
        width = [self partnerIsGallery] ? 200 : 270;
    }

    ARUnderLinedSwitchView *switchView = [[ARUnderLinedSwitchView alloc] initWithFrame:CGRectMake(0, 0, width, 60)];
    if ([UIDevice isPad]) {
        switchView.style = ARSwitchViewStyleSansSerif;

    } else if (![self partnerIsGallery] && [UIDevice hasHorizontallyConstrainedScreen]) {
        switchView.style = ARSwitchViewStyleSmallerSansSerif;
    } else {
        switchView.style = ARSwitchViewStyleSmallSansSerif;
    }

    NSString *artists = NSLocalizedString(@"Artists", @"Artist Collective Noun");
    NSString *shows = NSLocalizedString(@"Shows", @"Show Collective Noun");
    NSString *locations = NSLocalizedString(@"Locations", @"Location Collective Noun");
    NSString *albums = NSLocalizedString(@"Albums", @"Album Collective Noun");

    NSString *centerTitle = [self partnerIsGallery] ? shows : locations;
    [switchView setTitles:@[ artists, centerTitle, albums ]];

    NSInteger currentIndex = [self selectedIndexFromDisplayMode];
    [switchView setSelectedIndex:currentIndex animated:NO];

    switchView.center = self.navigationController.navigationBar.center;
    self.navigationItem.titleView = switchView;
    _switchView = switchView;
}

- (void)setDisplayMode:(enum ARDisplayMode)displayMode
{
    [self setDisplayMode:displayMode animated:NO];
}

- (void)setDisplayMode:(enum ARDisplayMode)displayMode animated:(BOOL)animated
{
    if (self.displayMode == displayMode) return;

    _displayMode = displayMode;
    NSInteger index = [self selectedIndexFromDisplayMode];

    [self.switchView setSelectedIndex:index animated:animated];
    [self.tabView setCurrentViewIndex:index animated:animated];
}

- (void)reloadCurrentViewController
{
    ARGridViewController *grid = (ARGridViewController *)[self.tabView currentViewController];
    [grid reloadData];
}

- (NSInteger)selectedIndexFromDisplayMode
{
    switch (self.displayMode) {
        case ARDisplayModeAllArtists:
            return ARTopViewControllerArtists;

        case ARDisplayModeAllShows:
            return ARTopViewControllerShows;

        case ARDisplayModeAllAlbums:
            return ARTopViewControllerAlbums;

        case ARDisplayModeAllLocations:
            return ARTopViewControllerLocations;

        default:
            NSLog(@"unknown selected Index");
            return -1;
    }
}

#pragma mark -
#pragma mark Create / Edit Albums

- (void)createNewAlbum
{
    ARNewAlbumModalViewController *createAlbumVC = [[ARNewAlbumModalViewController alloc] init];
    createAlbumVC.delegate = self;
    [self presentTransparentModalViewController:createAlbumVC animated:YES withAlpha:0.5];
}

- (void)modalViewController:(ARNewAlbumModalViewController *)controller didReturnStatus:(enum ARModalAlertViewControllerStatus)status
{
    [self dismissTransparentModalViewControllerAnimated:YES];
    if (status == ARModalAlertCancel) return;

    [ARAnalytics event:ARNewAlbumEvent withProperties:@{ @"from" : ARAlbumPage }];
    Album *album = [Album objectInContext:self.managedObjectContext];
    album.name = controller.inputTextField.text;
    album.createdAt = [NSDate date];

    [self.switchBoard pushEditAlbumViewController:album animated:YES];
}

- (void)toggleEditMode
{
    [self toggleEditModeAnimated:YES];
}

- (void)toggleEditModeAnimated:(BOOL)animated
{
    [self setEditing:!_editing animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    _editing = editing;

    [self dismissPopoversAnimated:animated];
    BOOL showingAlbumsOnPhone = (self.displayMode == ARDisplayModeAllAlbums) && ![UIDevice isPad];
    [self showBottomToolbar:showingAlbumsOnPhone || editing animated:animated];

    if ([self.tabView.currentViewController respondsToSelector:@selector(setIsEditing:)]) {
        [self.navigationController setNavigationBarHidden:self.editing animated:animated];

        NSString *buttonTitle = self.editing ? @"DONE" : @"EDIT";
        [self.bottomToolbar.button setTitle:buttonTitle forState:UIControlStateNormal];
        self.bottomToolbar.button.hidden = [UIDevice isPad] && !self.editing;

        ARGridViewController *mainVC = (ARGridViewController *)[_tabView currentViewController];
        NSArray *prefixes = editing ? @[ [self createAlbumItem] ] : nil;
        mainVC.gridView.prefixedObjects = prefixes;
        mainVC.isEditing = self.editing;

        if (!self.editing) {
            [mainVC reloadData];
        }
    }
}

- (ARImageGridViewItem *)createAlbumItem
{
    ARImageGridViewItem *item = [ARImageGridViewItem gridViewButton];
    [item setTarget:self action:@selector(createNewAlbum)];
    item.gridTitle = @"";
    item.gridSubtitle = @"";
    NSString *name = [UIDevice isPad] ? @"PadCreateAlbumButton@2x" : @"PhoneCreateAlbumButton@2x";
    item.imageFilepath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    return item;
}

- (void)showBottomToolbar:(BOOL)show animated:(BOOL)animated
{
    self.bottomToolbarHeightConstraint.constant = show ? self.bottomToolbar.intrinsicContentSize.height : 0;

    [UIView animateIf:animated duration:ARAnimationDuration:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (NSString *)pageID
{
    switch (self.displayMode) {
        case ARDisplayModeAllAlbums:
            return ARAllAlbumsPage;

        case ARDisplayModeAllArtists:
            return ARAllArtistsPage;

        case ARDisplayModeAllShows:
            return ARAllShowsPage;

        case ARDisplayModeAllLocations:
            return ARAllLocationsPage;

        default:
            NSLog(@"Unknown displayMode in pageID");
            return @"Unknown";
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

- (ARSwitchBoard *)switchBoard
{
    return _switchBoard ?: [ARSwitchBoard sharedSwitchboard];
}


@end

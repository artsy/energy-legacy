#import "ARNavigationController.h"
#import "ARNavigationBar.h"

#import "ARAppDelegate.h"

#import "ARGridViewController.h"

#import "ARSwitchBoard.h"
#import "ARSelectionToolbarView.h"
#import "ARRootNavigationControllerDelegate.h"

static ARNavigationController *sharedInstance = nil;


@interface ARNavigationController ()
@property (nonatomic, strong) UIBarButtonItem *searchBarButton;
@property (nonatomic, strong) ARPopoverController *searchPopoverController;
@property (nonatomic, strong) ARSearchViewController *searchViewController;
@property (nonatomic, strong) ARRootNavigationControllerDelegate *navDelegate;
@end


@implementation ARNavigationController

+ (ARNavigationController *)rootController
{
    static ARNavigationController *_sharedController = nil;
    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _sharedController = [[ARNavigationController alloc] init];
        [_sharedController observeNotification:ARDismissAllPopoversNotification globallyWithSelector:@selector(dismissPopovers)];
    });

    return _sharedController;
}

- (instancetype)init
{
    self = [super initWithNavigationBarClass:ARNavigationBar.class toolbarClass:nil];
    if (!self) return nil;

    _navDelegate = [[ARRootNavigationControllerDelegate alloc] init];
    self.delegate = _navDelegate;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationBar respondsToSelector:@selector(setExtendedHeight:)]) {
        [(id)self.navigationBar setExtendedHeight:[UIDevice isPad]];
    }

    [self setNavigationBarHidden:NO animated:NO];
}

- (void)setBarTransparency:(BOOL)transparent
{
    UIView *background = [self.navigationBar.subviews firstObject];
    if (transparent) {
        background.backgroundColor = [[UIColor artsyBackgroundColor] colorWithAlphaComponent:0.7];
    } else {
        background.backgroundColor = [UIColor artsyBackgroundColor];
    }
}

- (NSDictionary *)dictionaryForViewControllers
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController respondsToSelector:@selector(dictionaryForAnalytics)]) {
            ARGridViewController *controller = (ARGridViewController *)viewController;
            [dictionary addEntriesFromDictionary:[controller dictionaryForAnalytics]];
        }
    }
    return dictionary;
}

+ (NSString *)pageID
{
    UIViewController *vc = [[(ARAppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
    UINavigationController *nav = [vc isKindOfClass:[ARNavigationController class]] ? (UINavigationController *)vc : vc.navigationController;
    UIViewController *top = nav.topViewController;

    // Just in case this isn't an ARBaseVC subclass
    if ([top respondsToSelector:@selector(pageID)]) {
        return [(id)top pageID];

    } else {
        return @"Other";
    }
}

- (UIBarButtonItem *)newSearchPopoverButton
{
    _searchBarButton = [UIBarButtonItem toolbarImageButtonWithName:@"search" withTarget:self andSelector:@selector(showSearchPopover)];
    return _searchBarButton;
}

- (void)showSearchPopover
{
    if (_searchPopoverController.isPopoverVisible) {
        [self dismissPopoversAnimated:YES];

    } else {
        if (!self.searchViewController) {
            self.searchViewController = [ARSearchViewController sharedController];
            self.searchViewController.delegate = self;

            self.searchPopoverController = [[ARPopoverController alloc] initWithContentViewController:self.searchViewController];
            self.searchViewController.hostController = self.searchPopoverController;
        }


        [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];

        UIButton *searchButton = _searchBarButton.representedButton;
        searchButton.selected = YES;

        CGRect buttonFrame = [self.view convertRect:searchButton.frame fromView:[searchButton superview]];
        [self.searchPopoverController presentPopoverFromRect:buttonFrame
                                                      inView:self.view
                                    permittedArrowDirections:WYPopoverArrowDirectionUp
                                                    animated:YES];
        self.searchPopoverController.delegate = self;
    }
}

- (void)dismissPopovers
{
    [self dismissPopoversAnimated:YES];
}

- (void)dismissPopoversAnimated:(BOOL)animate
{
    [_searchViewController reset];
    [_searchPopoverController dismissPopoverAnimated:NO];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self dismissPopoversAnimated:animated];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self dismissPopovers];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - popover delegate methods

- (BOOL)popoverControllerShouldDismissPopover:(ARPopoverController *)aPopoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(ARPopoverController *)aPopoverController
{
    self.searchBarButton.representedButton.selected = NO;
}

#pragma mark -
#pragma mark Rotation


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.navigationBar.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];

    if (self.searchPopoverController.isPopoverVisible) {
        UIButton *searchButton = _searchBarButton.representedButton;
        CGRect buttonFrame = [self.view convertRect:searchButton.frame fromView:[searchButton superview]];

        [self.searchPopoverController presentPopoverFromRect:buttonFrame inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    }
}

#pragma mark -
#pragma mark ARSearchViewControllerDelegate methods

- (void)searchViewController:(ARSearchViewController *)aController didSelectAlbum:(Album *)album
{
    [ARAnalytics event:ARSearchSelectAlbumEvent];
    [[ARSwitchBoard sharedSwitchboard] jumpToAlbumViewController:album animated:YES];
}

- (void)searchViewController:(ARSearchViewController *)aController didSelectArtist:(Artist *)artist
{
    [ARAnalytics event:ARSearchSelectArtistEvent withProperties:@{ @"artist" : artist.name }];
    [[ARSwitchBoard sharedSwitchboard] jumpToArtistViewController:artist animated:YES];
}

- (void)searchViewController:(ARSearchViewController *)aController didSelectArtwork:(Artwork *)artwork
{
    [ARAnalytics event:ARSearchSelectArtworkEvent withProperties:@{ @"artist" : artwork.artistDisplayString }];
    [[ARSwitchBoard sharedSwitchboard] jumpToArtworkViewController:artwork context:[CoreDataManager mainManagedObjectContext]];
}

- (void)searchViewController:(ARSearchViewController *)aController didSelectShow:(Show *)show
{
    [ARAnalytics event:ARSearchSelectShowEvent withProperties:@{ @"show" : show.presentableName }];
    [[ARSwitchBoard sharedSwitchboard] jumpToShowViewController:show animated:YES];
}

- (void)searchViewController:(ARSearchViewController *)aController didSelectLocation:(Location *)location
{
    [ARAnalytics event:ARSearchSelectLocationEvent withProperties:@{ @"location" : location.name }];
    [[ARSwitchBoard sharedSwitchboard] jumpToLocationViewController:location animated:YES];
}

//- (void)viewSafeAreaInsetsDidChange
//{
//    [super viewSafeAreaInsetsDidChange];
//
//    CGFloat height = [UIDevice isPad] ? ARToolbarSizeHeight : ARToolbarSizeHeightPhone;
////    if (self.view.safeAreaInsets.top < height) {
//    self.additionalSafeAreaInsets = UIEdgeInsetsMake(height, 0, 0, 0);
////    }
//}

@end

#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>

#import "ARArtworkSetViewController.h"
#import "ARPadViewInRoomViewController.h"
#import "ARViewInRoomView.h"
#import "ARAddToAlbumViewController.h"
#import "NSFetchedResultsController+Count.h"
#import "ARNavigationController.h"
#import "ARModernArtworkMetadataViewController.h"
#import "ARPagingArtworkViewController.h"
#import "UIViewController+SimpleChildren.h"
#import "ARViewInRoomViewController.h"
#import "ARPopoverController.h"
#import "ARImageViewController.h"
#import "ARModernEmailArtworksViewController.h"

#if __has_include(<SafariServices/SafariServices.h>)
@import SafariServices;
#endif


@interface ARArtworkSetViewController () <ARPagingArtworkDataSource>

@property (nonatomic, strong) UIBarButtonItem *emailButton;
@property (nonatomic, strong) UIBarButtonItem *viewInRoom;
@property (nonatomic, strong) UIBarButtonItem *albumsButton;
@property (nonatomic, strong) UIBarButtonItem *editButton;

@property (nonatomic, strong) ARPopoverController *emailPopoverController;
@property (nonatomic, strong) ARPopoverController *albumPopoverController;
@property (nonatomic, strong) ARFolioImageMessageViewController *editArtworkViewController;

@property (nonatomic, assign, readonly) BOOL artworkInfoIsVisible;
@property (nonatomic, strong) NSFetchedResultsController *artworkResultsController;

@property (nonatomic, weak) ARPagingArtworkViewController *pagingViewController;
@property (nonatomic, weak) ARModernArtworkMetadataViewController *metadataViewController;

@end


@implementation ARArtworkSetViewController

- (instancetype)initWithArtworks:(NSFetchedResultsController *)artworks atIndex:(NSInteger)index representedObject:(ARManagedObject *)representedObject
{
    self = [super init];
    if (!self) return nil;

    _artworkInfoIsVisible = YES;
    _artworkResultsController = artworks;
    _representedObject = representedObject;
    _index = index;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ARPagingArtworkViewController *artworkController = [[ARPagingArtworkViewController alloc] initWithDelegate:self index:self.index];
    artworkController.delegate = self;

    [self ar_addChildViewController:artworkController atFrame:self.view.bounds];
    _pagingViewController = artworkController;

    UILabel *serifLabel = [[UILabel alloc] init];
    serifLabel.font = [UIFont serifFontWithSize:18];
    serifLabel.textColor = [UIColor artsyForegroundColor];
    serifLabel.frame = CGRectMake(0, 0, 80, 32);
    self.navigationItem.titleView = serifLabel;

    self.view.backgroundColor = [UIColor artsyBackgroundColor];

    ARModernArtworkMetadataViewController *metadataViewController = [[ARModernArtworkMetadataViewController alloc] init];
    metadataViewController.constrainedVerticalSpace = YES;
    metadataViewController.constrainedHorizontalSpace = ![UIDevice isPad];

    CGSize size = self.view.bounds.size;
    [self ar_addChildViewController:metadataViewController atFrame:CGRectMake(0, size.height - 72, size.width, 72)];
    _metadataViewController = metadataViewController;

    [self pageViewController:self.pagingViewController didFinishAnimating:YES previousViewControllers:@[] transitionCompleted:YES];

    [self observeNotification:ARToggleArtworkInfoNotification globallyWithSelector:@selector(toggleArtworkInfo:)];
    [self observeNotification:ARArtworkEnsureShowingMetadataNotification globallyWithSelector:@selector(showArtworkInfo:)];
    [self.view layoutIfNeeded];
}

- (void)viewWillLayoutSubviews
{
    CGFloat navHeight = CGRectGetHeight([self.navigationController navigationBar].bounds);
    CGRect extendedFrame = CGRectMake(0, -navHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) + navHeight);
    self.pagingViewController.view.frame = extendedFrame;
}

#pragma mark -
#pragma mark View Handling

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupArtworkToolbar];
    [(ARNavigationController *)self.navigationController setBarTransparency:YES];
    [ARAnalytics event:ARArtworkViewEvent withProperties:@{ @"artist" : self.currentArtwork.artist.name ?: @"" }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [(ARNavigationController *)self.navigationController setBarTransparency:NO];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -
#pragma mark Setup

- (void)setupArtworkToolbar
{
    self.viewInRoom = [UIBarButtonItem toolbarImageButtonWithName:@"View In Room" withTarget:self andSelector:@selector(viewInRoom:)];
    self.viewInRoom.representedButton.enabled = [self currentArtworkFitsInRoom];

    self.albumsButton = [UIBarButtonItem toolbarImageButtonWithName:@"Add To Album" withTarget:self andSelector:@selector(openAlbumPopover:)];
    self.emailButton = [UIBarButtonItem toolbarImageButtonWithName:@"Messages" withTarget:self andSelector:@selector(openEmailPopover:)];
    self.editButton = [UIBarButtonItem toolbarImageButtonWithName:@"Pencil" withTarget:self andSelector:@selector(openEditArtworkViewController:)];


    UIBarButtonItem *search = [(ARNavigationController *)self.navigationController newSearchPopoverButton];
    self.navigationItem.rightBarButtonItems = @[ search, self.viewInRoom, self.albumsButton, self.emailButton, self.editButton ];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed;
{
    if (!self.artworkCount) return;

    ARImageViewController *controller = self.pagingViewController.viewControllers.lastObject;
    _index = controller.index;

    self.titleLabel.text = [NSString stringWithFormat:@"%@  ⁄  %@", @(self.index + 1), @(self.artworkCount)];
    self.metadataViewController.artwork = [self artworkAtIndex:self.index];
    self.viewInRoom.representedButton.enabled = [self currentArtworkFitsInRoom];
}

#pragma mark -
#pragma mark Notifications

- (void)showArtworkInfo:(NSNotification *)notification
{
    [self setArtworkInfoIsVisible:YES animated:YES];
}

- (void)toggleArtworkInfo:(NSNotification *)notification
{
    [self setArtworkInfoIsVisible:!self.artworkInfoIsVisible animated:YES];
}

- (void)setArtworkInfoIsVisible:(BOOL)artworkInfoIsVisible animated:(BOOL)animated
{
    if (_artworkInfoIsVisible == artworkInfoIsVisible) return;

    _artworkInfoIsVisible = artworkInfoIsVisible;

    [UIView animateIf:animated duration:0.2:^{
        if (artworkInfoIsVisible) {
            self.navigationController.navigationBar.hidden = NO;
            self.navigationController.navigationBar.alpha = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:ARShowArtworkInfoNotification object:nil];
        } else {
            [ARAnalytics event:ARArtworkViewChromeHiddenEvent];
            self.navigationController.navigationBar.alpha = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:ARHideArtworkInfoNotification object:nil];
        }

    } completion:^(BOOL finished) {
        self.navigationController.navigationBar.hidden = !artworkInfoIsVisible;
    }];
}

#pragma mark -
#pragma mark Switching between detail views

- (void)viewInRoom:(id)sender
{
    [ARAnalytics event:ARArtworkViewInRoomEvent withProperties:@{ @"artist" : self.currentArtwork.artist.name ?: @"" }];

    [self dismissPopoversAnimated:YES];
    Artwork *artwork = [self currentArtwork];

    if ([UIDevice isPad]) {
        ARPadViewInRoomViewController *controller = [[ARPadViewInRoomViewController alloc] init];
        controller.hostView = self;
        controller.artwork = artwork;

        [self.navigationController presentViewController:controller animated:YES completion:nil];
    } else {
        ARViewInRoomViewController *phoneController = [[ARViewInRoomViewController alloc] initWithArtwork:artwork];
        phoneController.popOnRotation = NO;
        [self.navigationController presentViewController:phoneController animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark Creating Popovers

- (void)openEditArtworkViewController:(UIButton *)sender
{
    [self openEditArtworkViewControllerAnimated:YES];
}

- (void)openEditArtworkViewControllerAnimated:(BOOL)animate
{
    self.editArtworkViewController = [[ARFolioImageMessageViewController alloc] init];
    self.editArtworkViewController.delegate = self;
    self.editArtworkViewController.messageText = @"Visit your CMS to easily edit artworks";
    self.editArtworkViewController.buttonText = @"Edit artwork in CMS".uppercaseString;
    self.editArtworkViewController.image = [UIImage imageNamed:@"EditInCMSScreenshot"];

    NSString *address = [NSString stringWithFormat:@"https://cms.artsy.net/artworks/%@/edit?current_partner_id=%@", self.currentArtwork.slug, [Partner currentPartner].slug];
    self.editArtworkViewController.url = [NSURL URLWithString:address];

    [self presentViewController:self.editArtworkViewController animated:YES completion:nil];
}

- (void)dismissMessageViewController
{
    [self dismissMessageViewControllerAnimated:YES];
}

- (void)dismissMessageViewControllerAnimated:(BOOL)animate
{
    [self dismissViewControllerAnimated:animate completion:nil];
}


- (void)openEmailPopover:(UIButton *)sender
{
    NSParameterAssert(self.currentArtwork);

    if (!self.emailPopoverController.isPopoverVisible) {
        if (![ARModernEmailArtworksViewController canEmailArtworks]) {
            [ARModernEmailArtworksViewController presentNoMailAccountAlert];
            return;
        }

        sender.selected = YES;

        NSArray *artworks = @[ self.currentArtwork ];

        ARModernEmailArtworksViewController *emailController = [[ARModernEmailArtworksViewController alloc] initWithArtworks:artworks documents:nil context:self.representedObject];
        emailController.hostViewController = self;

        self.emailPopoverController = [[ARPopoverController alloc] initWithContentViewController:emailController];
        self.emailPopoverController.delegate = self;

        // Only show the popover if we need to
        if ([emailController hasAdditionalOptions]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];


            CGRect buttonFrame = [self.view convertRect:sender.frame fromView:[sender superview]];
            [self.emailPopoverController presentPopoverFromRect:buttonFrame
                                                         inView:self.view
                                       permittedArrowDirections:WYPopoverArrowDirectionUp
                                                       animated:YES];
        } else {
            [emailController emailArtworks];
        }

    } else {
        [self.emailPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)openAlbumPopover:(UIButton *)sender
{
    if (self.albumPopoverController.isPopoverVisible) {
        [self.albumPopoverController dismissPopoverAnimated:YES];
        return;
    }

    [self dismissPopoversAnimated:YES];
    sender.selected = YES;

    NSManagedObjectContext *context = [CoreDataManager mainManagedObjectContext];
    ARAddToAlbumViewController *controller = [[ARAddToAlbumViewController alloc] initWithManagedObjectContext:context];
    Artwork *artwork = self.currentArtwork;
    if (artwork) {
        controller.artworks = @[ artwork ];
    }

    self.albumPopoverController = [[ARPopoverController alloc] initWithContentViewController:controller];
    self.albumPopoverController.delegate = self;

    CGRect buttonFrame = [self.view convertRect:sender.frame fromView:sender.superview];
    controller.container = self.albumPopoverController;

    [self.albumPopoverController presentPopoverFromRect:buttonFrame
                                                 inView:self.view
                               permittedArrowDirections:WYPopoverArrowDirectionUp
                                               animated:YES];
}

#pragma mark -
#pragma mark Popovers dismissal

- (void)dismissPopoversAnimated:(BOOL)animate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];

    [self.albumPopoverController dismissPopoverAnimated:animate];
    [self.emailPopoverController dismissPopoverAnimated:animate];
}

- (BOOL)popoverControllerShouldDismissPopover:(ARPopoverController *)aPopoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(ARPopoverController *)aPopoverController
{
    self.emailButton.representedButton.selected = self.emailPopoverController.isPopoverVisible;
    self.albumsButton.representedButton.selected = self.albumPopoverController.isPopoverVisible;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark Mail Composer

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            [ARAnalytics event:AREmailSentEvent];
            break;
        case MFMailComposeResultCancelled:
            [ARAnalytics event:AREmailCancelledEvent];
            break;
        default:
            ;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    self.emailButton.representedButton.selected = NO;
    [self.emailPopoverController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark Helpers

- (UILabel *)titleLabel
{
    return [self.navigationItem.titleView isKindOfClass:UILabel.class] ? (id)self.navigationItem.titleView : nil;
}

- (BOOL)currentArtworkFitsInRoom
{
    return [ARViewInRoomView canShowArtwork:self.currentArtwork];
}

- (NSString *)pageID
{
    return ARArtworkPage;
}

- (NSDictionary *)dictionaryForAnalytics
{
    return @{ @"artwork_id" : self.currentArtwork.title ?: @"" };
}

#pragma mark -
#pragma mark Artwork Helpers

- (Artwork *)currentArtwork
{
    return [self artworkAtIndex:self.index];
}

- (Artwork *)nextArtwork
{
    return [self artworkAtIndex:self.index + 1];
}

- (Artwork *)previousArtwork
{
    return [self artworkAtIndex:self.index - 1];
}

- (Artwork *)artworkAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.artworkCount) return nil;

    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    return [self.artworkResultsController objectAtIndexPath:path];
}

- (NSUInteger)artworkCount
{
    return self.artworkResultsController.count;
}

@end

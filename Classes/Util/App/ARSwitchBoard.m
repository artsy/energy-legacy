#import "ARSwitchBoard.h"
#import "ARNavigationController.h"
#import "ARAlbumEditNavigationController.h"
#import "ARNavigationBar.h"
#import "ARContentControllers.h"
#import "CoreDataManager.h"
#import <JLRoutes/JLRoutes.h>


@interface ARSwitchBoard ()
@property (nonatomic, strong) JLRoutes *router;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) UINavigationController *navigationController;
@end


@implementation ARSwitchBoard

+ (ARSwitchBoard *)sharedSwitchboard
{
    static ARSwitchBoard *_sharedController = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        ARNavigationController *controller = [ARNavigationController rootController];
        NSManagedObjectContext *context = [CoreDataManager mainManagedObjectContext];
        _sharedController = [[ARSwitchBoard alloc] initWithNavigationController:controller context:context];
    });

    return _sharedController;
}

- (instancetype)initWithNavigationController:(UINavigationController *)controller context:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) return nil;

    JLRoutes *router = [[JLRoutes alloc] init];

    [router addRoute:@"/artist/:artist_id" handler:^BOOL(NSDictionary *parameters) {

        Artist *artist = [Artist findFirstByAttribute:@"slug" withValue:parameters[@"artist_id"] inContext:context];
        if (!artist) return NO;

        [self pushArtistViewController:artist animated:NO];
        return YES;
    }];

    [router addRoute:@"/artist/:artist_id/artwork/:artwork_id" handler:^BOOL(NSDictionary *parameters) {

        Artist *artist = [Artist findFirstByAttribute:@"slug" withValue:parameters[@"artist_id"] inContext:context];
        if (!artist) return NO;

        Artwork *artwork = [Artwork findFirstByAttribute:@"slug" withValue:parameters[@"artwork_id"] inContext:context];
        if (!artwork) return NO;

        [self jumpToArtistViewController:artist animated:NO];

        NSFetchRequest *fetchRequest = [artist artworksFetchRequestSortedBy:ARArtworksSortOrderDefault];
        NSFetchedResultsController *controller = [self fetchedResultsControllerForArtworksRequest:fetchRequest];

        NSInteger index = [controller indexPathForObject:artwork].row;
        [self pushArtworkViewControllerWithArtworks:controller atIndex:index representedObject:artist];

        return YES;
    }];

    [router addRoute:@"/show/:show_id" handler:^BOOL(NSDictionary *parameters) {
        Show *show = [self getShowByID:parameters[@"show_id"]];
        if (!show) return NO;

        [self pushShowViewController:show animated:NO];
        return YES;
    }];

    [router addRoute:@"/show/:show_id/artwork/:artwork_id" handler:^BOOL(NSDictionary *parameters) {
        Show *show = [self getShowByID:parameters[@"show_id"]];
        if (!show) return NO;

        Artwork *artwork = [Artwork findFirstByAttribute:@"slug" withValue:parameters[@"artwork_id"] inContext:context];
        if (!artwork) return NO;

        [self jumpToShowViewController:show animated:NO];

        NSFetchRequest *fetchRequest = [show artworksFetchRequestSortedBy:ARArtworksSortOrderDefault];
        NSFetchedResultsController *controller = [self fetchedResultsControllerForArtworksRequest:fetchRequest];

        NSInteger index = [controller indexPathForObject:artwork].row;
        [self pushArtworkViewControllerWithArtworks:controller atIndex:index representedObject:show];
        return YES;
    }];

    [router addRoute:@"/album/:album_id" handler:^BOOL(NSDictionary *parameters) {
        Album *album = [Album findFirstByAttribute:@"slug" withValue:parameters[@"album_id"] inContext:context];
        if (!album) return NO;

        [self jumpToAlbumViewController:album animated:NO];
        return YES;
    }];

    [router addRoute:@"/album/:album_id/artwork/:artwork_id" handler:^BOOL(NSDictionary *parameters) {
        Album *album = [Album findFirstByAttribute:@"slug" withValue:parameters[@"album_id"] inContext:context];
        if (!album) return NO;

        Artwork *artwork = [Artwork findFirstByAttribute:@"slug" withValue:parameters[@"artwork_id"] inContext:context];
        if (!artwork) return NO;

        [self jumpToAlbumViewController:album animated:NO];
        NSFetchRequest *fetchRequest = [album artworksFetchRequestSortedBy:ARArtworksSortOrderDefault];
        NSFetchedResultsController *controller = [self fetchedResultsControllerForArtworksRequest:fetchRequest];

        NSInteger index = [controller indexPathForObject:artwork].row;
        [self pushArtworkViewControllerWithArtworks:controller atIndex:index representedObject:album];
        return YES;
    }];

    _router = router;
    _context = context;
    _navigationController = controller;
    return self;
}

- (Show *)getShowByID:(NSString *)slug
{
    // Use the internal Slug lookup
    Show *show = [Show findFirstByAttribute:@"slug" withValue:slug inContext:self.context];

    if (!show) {
        // Failing that try an artsy website slug ( includes the partner )
        show = [Show findFirstByAttribute:@"showSlug" withValue:slug inContext:self.context];
    }

    return show;
}

#pragma mark pushing

- (void)pushArtistViewController:(Artist *)artist animated:(BOOL)animates
{
    ARArtistViewController *controller = [[ARArtistViewController alloc] initWithArtist:artist];
    [self.navigationController pushViewController:controller animated:animates];
}

- (void)pushShowViewController:(Show *)show animated:(BOOL)animates
{
    ARShowViewController *controller = [[ARShowViewController alloc] initWithShow:show];
    [self.navigationController pushViewController:controller animated:animates];
}

- (ARAlbumEditNavigationController *)pushEditAlbumViewController:(Album *)album animated:(BOOL)animates
{
    ARAlbumEditNavigationController *navController = [[ARAlbumEditNavigationController alloc] initWithAlbum:album];
    AREditAlbumViewController *controller = [[AREditAlbumViewController alloc] initWithAlbum:album];
    [navController setViewControllers:@[ controller ] animated:NO];

    [self.navigationController presentViewController:navController animated:animates completion:nil];
    return navController;
}

- (void)pushAlbumViewController:(Album *)album animated:(BOOL)animates
{
    ARAlbumViewController *controller = [[ARAlbumViewController alloc] initWithAlbum:album];
    [self.navigationController pushViewController:controller animated:animates];
}

- (void)pushDocumentSet:(NSArray<Document *> *)documents index:(NSInteger)index animated:(BOOL)animates
{
    ARModernDocumentPreviewViewController *previewer = [[ARModernDocumentPreviewViewController alloc] initWithDocumentSet:documents index:index];
    [self.navigationController pushViewController:previewer animated:animates];
}

- (void)pushImageViews:(NSArray *)images index:(NSInteger)index animated:(BOOL)animates
{
    ARImageSetViewController *controller = [[ARImageSetViewController alloc] initWithImages:images atIndex:index];
    [self.navigationController pushViewController:controller animated:animates];
}

- (void)pushLocationView:(Location *)location animated:(BOOL)animates
{
    ARTabbedViewController *controller = [[ARTabbedViewController alloc] initWithRepresentedObject:location];
    [self.navigationController pushViewController:controller animated:animates];
}

#pragma mark setting a new nav heirarchy

- (void)jumpToViewController:(UIViewController *)controller withDisplayMode:(enum ARDisplayMode)mode animated:(BOOL)animates
{
    // Fade, empty stack,
    UINavigationController *navController = [self navigationController];

    [UIView animateSpringIf:animates duration:ARAnimationQuickDuration delay:0 damping:1 velocity:1:^{
        navController.view.alpha = 0;

    } completion:^(BOOL finished) {
        [navController popToRootViewControllerAnimated:NO];
        [ARTopViewController sharedInstance].displayMode = mode;
        [navController pushViewController:controller animated:NO];

        [UIView animateIf:animates duration:ARAnimationQuickDuration:^{
            [navController view].alpha = 1;
        }];
    }];
}

- (void)jumpToArtistViewController:(Artist *)artist animated:(BOOL)animates
{
    ARArtistViewController *controller = [[ARArtistViewController alloc] initWithArtist:artist];
    [self jumpToViewController:controller withDisplayMode:ARDisplayModeAllArtists animated:animates];
}

- (void)jumpToShowViewController:(Show *)show animated:(BOOL)animates
{
    ARShowViewController *controller = [[ARShowViewController alloc] initWithShow:show];
    [self jumpToViewController:controller withDisplayMode:ARDisplayModeAllShows animated:animates];
}

- (void)jumpToAlbumViewController:(Album *)album animated:(BOOL)animates
{
    ARAlbumViewController *controller = [[ARAlbumViewController alloc] initWithAlbum:album];
    [self jumpToViewController:controller withDisplayMode:ARDisplayModeAllAlbums animated:animates];
}

- (void)jumpToLocationViewController:(Location *)location animated:(BOOL)animates
{
    ARTabbedViewController *controller = [[ARTabbedViewController alloc] initWithRepresentedObject:location];
    [self jumpToViewController:controller withDisplayMode:ARDisplayModeAllLocations animated:animates];
}

- (void)jumpToArtworkViewController:(Artwork *)artwork context:(NSManagedObjectContext *)context
{
    // Empty the navigation controllers stack
    // then put a ArtistVC with the artwork's artist in it
    // then put in the ArtworkdetailVC for the artwork at the right index

    ARArtistViewController *artistController = [[ARArtistViewController alloc] initWithArtist:artwork.artists.anyObject];

    NSFetchRequest *fetchRequest = [artistController.representedObject artworksFetchRequestSortedBy:ARArtworksSortOrderDefault];
    NSFetchedResultsController *controller = [self fetchedResultsControllerForArtworksRequest:fetchRequest];

    NSInteger index = [controller indexPathForObject:artwork].row;
    ARArtworkSetViewController *artworkController = [[ARArtworkSetViewController alloc] initWithArtworks:controller atIndex:index representedObject:artwork.artists.anyObject defaults:[NSUserDefaults standardUserDefaults]];

    UINavigationController *navController = [self navigationController];
    [UIView animateWithDuration:ARAnimationQuickDuration animations:^{
        [navController view].alpha = 0;

    } completion:^(BOOL finished) {
        [navController popToRootViewControllerAnimated:NO];

        [ARTopViewController sharedInstance].displayMode = ARDisplayModeAllArtists;

        [navController pushViewController:artistController animated:NO];
        [navController pushViewController:artworkController animated:NO];

        [UIView animateWithDuration:ARAnimationQuickDuration animations:^{
            [navController view].alpha = 1;
        }];
    }];
}

- (NSFetchedResultsController *)fetchedResultsControllerForArtworksRequest:(NSFetchRequest *)request
{
    NSFetchedResultsController *artworks = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                               managedObjectContext:self.context
                                                                                 sectionNameKeyPath:nil
                                                                                          cacheName:nil];
    NSError *err = nil;
    if (![artworks performFetch:&err]) {
        NSLog(@"Couldn't perform fetch for Artwork Detail View %@", err);
    }
    return artworks;
}

- (void)pushArtworkViewControllerWithArtworks:(NSFetchedResultsController *)artworks atIndex:(NSInteger)index representedObject:(ARManagedObject *)representedObject
{
    ARArtworkSetViewController *artworkController = [[ARArtworkSetViewController alloc] initWithArtworks:artworks atIndex:index representedObject:representedObject defaults:[NSUserDefaults standardUserDefaults]];
    [self.navigationController pushViewController:artworkController animated:YES];
}

- (void)jumpToArtworkViewControllerWithArtworkName:(NSString *)artworkID inContext:(NSManagedObjectContext *)context
{
    Artwork *artwork = [Artwork findFirstByAttribute:@keypath(Artwork.new, title) withValue:artworkID inContext:context];
    if (artwork) {
        [self jumpToArtworkViewController:artwork context:context];
    } else {
        NSLog(@"%%%%%%%%%%%%%% Could not find artwork");
    }
}

- (void)jumpToShowViewControllerWithShowName:(NSString *)showName inContext:(NSManagedObjectContext *)context;
{
    Show *show = [Show findFirstByAttribute:@keypath(Show.new, name) withValue:showName inContext:context];
    if (show) {
        [self jumpToShowViewController:show animated:NO];
    } else {
        NSLog(@"%%%%%%%%%%%%%% Could not find show");
    }
}

@end

#import "ARSwitchBoard.h"
#import "ARContentControllers.h"
#import "ARNavigationController.h"
#import <JLRoutes/JLRoutes.h>


@interface ARSwitchBoard ()
+ (ARNavigationController *)navigationController;
@end

SpecBegin(ARSwitchBoard);

__block UINavigationController *navController;
__block NSManagedObjectContext *context;
__block ARSwitchBoard *subject;

before(^{
    navController = [[UINavigationController alloc] init];
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [[ARSwitchBoard alloc] initWithNavigationController:navController context:context];
});

it(@"pushes an artistVC", ^{
    Artist *artist = [Artist stubbedArtistWithPublishedArtworks:NO inContext:context];
    [subject pushArtistViewController:artist animated:NO];
    expect(navController.topViewController).to.beAKindOf(ARArtistViewController.class);
});

it(@"routes an Artist URL", ^{
    Artist *artist = [Artist stubbedArtistWithPublishedArtworks:NO inContext:context];
    artist.slug = @"hello";
    NSURL *url = [NSURL URLWithString:@"https://artsy.net/artist/hello"];

    [subject.router routeURL:url];

    id topVC = navController.topViewController;
    expect(topVC).to.beAKindOf(ARArtistViewController.class);
    expect([topVC representedObject]).to.equal(artist);
});

it(@"doesnt route an artist that doesn't exist", ^{
    [Artist stubbedArtistWithPublishedArtworks:NO inContext:context];
    NSURL *url = [NSURL URLWithString:@"https://artsy.net/artist/hello"];
    [subject.router routeURL:url];

    expect(navController.topViewController).to.beFalsy();
});

it(@"pushes a show vc", ^{
    Show *show = [Show modelFromJSON:@{ @"id" : @"a_show" } inContext:context];
    [subject pushShowViewController:show animated:NO];
    expect(navController.topViewController).to.beAKindOf(ARShowViewController.class);
});

it(@"routes an Show URL via slug", ^{
    Show *show = [Show modelFromJSON:@{} inContext:context];
    show.slug = @"a_shot";
    NSURL *url = [NSURL URLWithString:@"https://artsy.net/show/a_shot"];

    [subject.router routeURL:url];

    id topVC = navController.topViewController;
    expect(topVC).to.beAKindOf(ARShowViewController.class);
    expect([topVC representedObject]).to.equal(show);
});

it(@"routes an Show URL via show slug", ^{
    Show *show = [Show modelFromJSON:@{} inContext:context];
    show.showSlug = @"hello";
    NSURL *url = [NSURL URLWithString:@"https://artsy.net/show/hello"];

    [subject.router routeURL:url];

    id topVC = navController.topViewController;
    expect(topVC).to.beAKindOf(ARShowViewController.class);
    expect([topVC representedObject]).to.equal(show);
});

it(@"expects an AlbumVC on a push", ^{
    Album *album = [Album modelFromJSON:@{} inContext:context];
    [subject pushAlbumViewController:album animated:NO];
    expect(navController.topViewController).to.beAKindOf(ARAlbumViewController.class);
});

pending(@"expects an DocumentsVC on a push", ^{
    Document *document = [Document modelFromJSON:@{} inContext:context];
    [subject pushDocumentSet:@[ document ] index:0 animated:NO];

    expect(navController.topViewController).to.beAKindOf(ARModernDocumentPreviewViewController.class);
});

it(@"expects an ArtworkVC on a push", ^{
    [Artwork modelFromJSON:@{} inContext:context];
    NSFetchedResultsController *results = [Artwork allArtworksInContext:context];
    [subject pushArtworkViewControllerWithArtworks:results atIndex:0 representedObject:nil];

    expect(navController.topViewController).to.beAKindOf(ARArtworkSetViewController.class);
});

SpecEnd

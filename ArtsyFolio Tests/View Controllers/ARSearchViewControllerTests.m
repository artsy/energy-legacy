#import "ARSearchViewController.h"
#import "ARBrowseProvider.h"

SpecBegin(ARSearchViewController);

__block NSManagedObjectContext *context;
__block ARSearchViewController *sut;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    sut = [[ARSearchViewController alloc] init];
    sut.managedObjectContext = context;
});


describe(@"looks", ^{
    it(@"correct by default", ^{
        expect(sut).to.haveValidSnapshot();
    });

    it(@"with artists", ^{
        Artist *artist = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
        artist.name = @"Mr Marmite";
        expect(sut).to.haveValidSnapshot();
    });

    it(@"highlights selected item", ^{
        Artist *artist = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
        artist.name = @"Mr Marmite";
        artist.orderingKey = @"a";
        Artist *artist2 = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
        artist2.name = @"Mrs Bagel";
        artist2.orderingKey = @"b";

        sut.selectedItem = artist2;
        expect(sut).to.haveValidSnapshot();
    });

    it(@"has location instead of shows with a collector partner", ^{
        [Partner modelFromJSON:@{ @"type" : @"Private Collector" } inContext:context];

        Artist *artist = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
        artist.name = @"Mr Marmite";
        artist.orderingKey = @"a";
        Artist *artist2 = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
        artist2.name = @"Mrs Bagel";
        artist2.orderingKey = @"b";
        Artist *artist3 = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
        artist3.name = @"Lady Toaster";
        artist3.orderingKey = @"c";

        expect(sut).to.haveValidSnapshot();
    });
});

describe(@"supports browsing", ^{
    before(^{
        [sut beginAppearanceTransition:YES animated:NO];
        [sut endAppearanceTransition];
    });

    it(@"Artists", ^{
        [sut switchView:nil didSelectIndex:0 animated:NO];
        expect(sut.browseProvider.currentDisplayMode).to.equal(ARBrowseDisplayModeArtists);
    });

    it(@"Shows", ^{
        [sut switchView:nil didSelectIndex:1 animated:NO];
        expect(sut.browseProvider.currentDisplayMode).to.equal(ARBrowseDisplayModeShows);
    });

    it(@"Locations", ^{
        // Adds a collector partner
        [Partner modelFromJSON:@{ @"type" : @"Private Collector" } inContext:context];

        [sut switchView:nil didSelectIndex:1 animated:NO];
        expect(sut.browseProvider.currentDisplayMode).to.equal(ARBrowseDisplayModeLocations);

    });

    it(@"Albums", ^{
        [sut switchView:nil didSelectIndex:2 animated:NO];
        expect(sut.browseProvider.currentDisplayMode).to.equal(ARBrowseDisplayModeAlbums);
    });

    it(@"Albums when with a collector", ^{
        [Partner modelFromJSON:@{ @"type" : @"Private Collector" } inContext:context];

        [sut switchView:nil didSelectIndex:2 animated:NO];
        expect(sut.browseProvider.currentDisplayMode).to.equal(ARBrowseDisplayModeAlbums);
    });
});

describe(@"supports finding", ^{
    it(@"ignores artworks with no images", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{} inContext:context];
        artwork.title = @"Hi";
        [sut performSearchForText:@"hi"];
        expect([sut searchResults].count).to.equal(0);
    });

    it(@"artworks by title", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{} inContext:context];
        artwork.title = @"Hi";
        Image *image = [Image modelFromJSON:@{} inContext:context];
        artwork.images = [NSSet setWithObject:image];

        [sut performSearchForText:@"hi"];
        expect([sut searchResults].count).to.equal(1);
    });

    it(@"Artists by name", ^{
        Artist *artist = [Artist modelFromJSON:@{} inContext:context];
        artist.name = @"hello there";

        [sut performSearchForText:@"he"];
        expect([sut searchResults].count).to.equal(1);
    });

    it(@"Shows by name", ^{
        Show *show = [Show modelFromJSON:@{} inContext:context];
        show.name = @"its a show";

        [sut performSearchForText:@"its"];
        expect([sut searchResults].count).to.equal(1);
    });

    it(@"Locations by name", ^{
        Location *location = [Location modelFromJSON:@{} inContext:context];
        location.name = @"its a location";

        [sut performSearchForText:@"its"];
        expect([sut searchResults].count).to.equal(1);
    });

    it(@"Albums by name", ^{
        Album *album = [Album modelFromJSON:@{} inContext:context];
        album.name = @"its an album";

        [sut performSearchForText:@"its"];
        expect([sut searchResults].count).to.equal(1);
    });
});


describe(@"tapping a results sends the right message to the delegate", ^{

    __block NSIndexPath *zeroPath;
    __block OCMockObject *delegateMock;
    __block UITableView *tableView;


    before(^{
        tableView = [[UITableView alloc] init];
        delegateMock = [OCMockObject mockForProtocol:@protocol(ARSearchViewControllerDelegate)];
        sut.delegate = (id)delegateMock;
        zeroPath= [NSIndexPath indexPathForRow:0 inSection:0];
    });

    it(@"artworks", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{} inContext:context];
        artwork.title = @"Hi";
        Image *image = [Image modelFromJSON:@{} inContext:context];
        artwork.images = [NSSet setWithObject:image];

        [[delegateMock expect] searchViewController:sut didSelectArtwork:artwork];

        [sut performSearchForText:@"hi"];
        [sut tableView:tableView didSelectRowAtIndexPath:zeroPath];

        expect(^{ [delegateMock verify]; }).toNot.raiseAny();
    });

    it(@"Artists", ^{
        Artist *artist = [Artist modelFromJSON:@{} inContext:context];
        artist.name = @"hello there";

        [[delegateMock expect] searchViewController:sut didSelectArtist:artist];

        [sut performSearchForText:@"he"];
        [sut tableView:tableView didSelectRowAtIndexPath:zeroPath];

        expect(^{ [delegateMock verify]; }).toNot.raiseAny();
    });

    it(@"Shows", ^{
        Show *show = [Show modelFromJSON:@{} inContext:context];
        show.name = @"its a show";

        [[delegateMock expect] searchViewController:sut didSelectShow:show];

        [sut performSearchForText:@"its"];
        [sut tableView:tableView didSelectRowAtIndexPath:zeroPath];

        expect(^{ [delegateMock verify]; }).toNot.raiseAny();
    });

    it(@"Locations", ^{
        Location *location = [Location modelFromJSON:@{} inContext:context];
        location.name = @"its a location";

        [[delegateMock expect] searchViewController:sut didSelectLocation:location];

        [sut performSearchForText:@"its"];
        [sut tableView:tableView didSelectRowAtIndexPath:zeroPath];

        expect(^{ [delegateMock verify]; }).toNot.raiseAny();
    });

    it(@"Albums", ^{
        Album *album = [Album modelFromJSON:@{} inContext:context];
        album.name = @"its an album";

        [[delegateMock expect] searchViewController:sut didSelectAlbum:album];

        [sut performSearchForText:@"its"];
        [sut tableView:tableView didSelectRowAtIndexPath:zeroPath];

        expect(^{ [delegateMock verify]; }).toNot.raiseAny();
    });

});

SpecEnd

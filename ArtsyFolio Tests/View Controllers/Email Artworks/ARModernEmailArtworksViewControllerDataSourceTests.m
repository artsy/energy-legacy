#import "ARModernEmailArtworksViewControllerDataSource.h"
#import "InstallShotImage.h"

SpecBegin(ARModernEmailArtworksViewControllerDataSource);

__block NSArray *artworks, *documents;
__block ARModernEmailArtworksViewControllerDataSource *subject;
__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [[ARModernEmailArtworksViewControllerDataSource alloc] init];
});

describe(@"showing additional images", ^{
    it(@"returns true only when there's one artwork with additional images", ^{
        Artwork *artwork = [Artwork objectInContext:context];
        artwork.images = [NSSet setWithObjects:[Image objectInContext:context], [Image objectInContext:context], nil];
        expect([subject artworksShouldShowAdditionalImages:@[artwork]]).to.beTruthy();
    });

    it(@"returns false when there's two artworks, even if one has additional images", ^{
        Artwork *artwork = [Artwork objectInContext:context];
        artwork.images = [NSSet setWithObjects:[Image objectInContext:context], [Image objectInContext:context], nil];
        Artwork *artwork2 = [Artwork objectInContext:context];
        expect([subject artworksShouldShowAdditionalImages:@[artwork, artwork2]]).to.beFalsy();
    });

    it(@"returns false the artwork has no additional images", ^{
        Artwork *artwork = [Artwork objectInContext:context];
        expect([subject artworksShouldShowAdditionalImages:@[artwork]]).to.beFalsy();
    });
});

describe(@"showing prices", ^{
    it(@"returns true when there's one artwork with pricing", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{ ARFeedPriceKey : @"23"} inContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowPrice:@[artwork, artwork2]]).to.beTruthy();
    });

    it(@"returns false when there's one artwork with pricing but it is 0 length", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{ ARFeedPriceKey : @""} inContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowPrice:@[artwork, artwork2]]).to.beFalsy();
    });

    it(@"returns false if no artworks have a price", ^{
        Artwork *artwork = [Artwork objectInContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowPrice:@[artwork, artwork2]]).to.beFalsy();
    });
});

describe(@"showing backend prices", ^{
    it(@"returns true when there's one artwork with pricing", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{ ARFeedPriceKey : @"23", ARFeedInternalPriceKey: @"24" } inContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowPrice:@[artwork, artwork2]]).to.beTruthy();
    });


    it(@"returns false when there's one artwork with the same display price as internal price", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{ ARFeedPriceKey : @"23", ARFeedInternalPriceKey : @"23" } inContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowBackendPrice:@[artwork, artwork2]]).to.beFalsy();
    });

    it(@"returns false when there's one artwork with pricing but it is 0 length", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{ ARFeedPriceKey : @""} inContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowBackendPrice:@[artwork, artwork2]]).to.beFalsy();
    });

    it(@"returns false if no artworks have a price", ^{
        Artwork *artwork = [Artwork objectInContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowBackendPrice:@[artwork, artwork2]]).to.beFalsy();
    });
});


describe(@"showing supplementary info", ^{
    it(@"returns true when there's one artwork has Supplementary info", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{ ARFeedSeriesKey : @"23"} inContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowSupplementaryInfo:@[artwork, artwork2]]).to.beTruthy();
    });

    it(@"returns false if no artworks have Supplementary info", ^{
        Artwork *artwork = [Artwork objectInContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowSupplementaryInfo:@[artwork, artwork2]]).to.beFalsy();
    });
});

describe(@"showing inventory ID", ^{
    it(@"returns true when there's one artwork with an inventory ID", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{ ARFeedInventoryIDKey : @"23"} inContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowInventoryID:@[artwork, artwork2]]).to.beTruthy();
    });

    it(@"returns false if no artworks have an inventory ID", ^{
        Artwork *artwork = [Artwork objectInContext:context];
        Artwork *artwork2 = [Artwork objectInContext:context];

        expect([subject artworksShouldShowInventoryID:@[artwork, artwork2]]).to.beFalsy();
    });
});

describe(@"installation shots", ^{
    __block InstallShotImage *image;
    __block Artwork *artwork;
    __block Show *show;

    beforeEach(^{
        image = [InstallShotImage objectInContext:context];
        artwork = [Artwork objectInContext:context];
        show = [Show objectInContext:context];
    });

    it(@"returns true when there is one show with installation shots in artworks", ^{
        show.installationImages = [NSSet setWithObject:image];
        show.artworks = [NSSet setWithObject:artwork];

        NSArray *installationShots = [subject installationShotsForArtworks:@[artwork] context:nil];
        expect(installationShots.count).to.beGreaterThan(0);
        expect([subject artworksShouldShowInstallShots:@[artwork] context:nil]).to.beTruthy();
    });

    it(@"returns true when there is a context as a show with installation shots", ^{
        Show *show2 = [Show objectInContext:context];

        show.installationImages = [NSSet setWithObject:image];
        show.artworks = [NSSet setWithObject:artwork];
        show2.artworks = [NSSet setWithObject:artwork];

        NSArray *installationShots = [subject installationShotsForArtworks:@[show] context:show];
        expect(installationShots.count).to.beGreaterThan(0);
        expect([subject artworksShouldShowInstallShots:@[artwork] context:nil]).to.beTruthy();
    });

    it(@"returns false if no artworks with shows have installation shots", ^{
        show.artworks = [NSSet setWithObject:artwork];

        NSArray *installationShots = [subject installationShotsForArtworks:@[show] context:show];
        expect(installationShots.count).to.equal(0);
        expect([subject artworksShouldShowInstallShots:@[artwork] context:nil]).to.beFalsy();
    });


    it(@"returns false if there are more that one show with installation shots and no context", ^{
        Show *show2 = [Show objectInContext:context];
        show2.slug = @"2";

        InstallShotImage *image2 = [InstallShotImage objectInContext:context];

        show.installationImages = [NSSet setWithObject:image];
        show.artworks = [NSSet setWithObject:artwork];

        show2.installationImages = [NSSet setWithObject:image2];
        show2.artworks = [NSSet setWithObject:artwork];
        artwork.shows = [NSSet setWithObjects:show, show2, nil];

        NSArray *installationShots = [subject installationShotsForArtworks:@[artwork] context:nil];
        expect(installationShots.count).to.equal(0);
        expect([subject artworksShouldShowInstallShots:@[artwork] context:nil]).to.beFalsy();
    });
});

describe(@"document containers", ^{
    it(@"returns all document containers related to artworks / docs", ^{
        Document *document = [Document objectInContext:context];
        document.hasFile = @YES;

        // An artist
        Artist *artist = [Artist objectInContext:context];
        artist.documents = [NSSet setWithObject:document];
        Artwork *artwork = [Artwork objectInContext:context];
        artwork.artist = artist;

        // A show
        Show *show = [Show objectInContext:context];
        show.documents = [NSSet setWithObject:document];
        Artwork *artwork2 = [Artwork objectInContext:context];
        show.artworks = [NSSet setWithObject:artwork2];

        artworks = @[artwork, artwork2];
        documents = @[document];

        NSArray *unsorted = [subject arrayOfRelatedShowDocumentContainersForArtworks:artworks documents:documents];
        expect(unsorted).to.contain(artist);
        expect(unsorted).to.contain(show);

        NSArray *sorted = [subject sortedArrayOfRelatedShowDocumentContainersForArtworks:artworks documents:documents];
        expect(sorted).to.contain(artist);
        expect(sorted).to.contain(show);
    });

});


SpecEnd

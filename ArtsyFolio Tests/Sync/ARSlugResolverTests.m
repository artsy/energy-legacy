#import "ARSlugResolver.h"
#import "Artwork.h"
#import "ModelStubs.h"
#import "Album.h"
#import "Show.h"
#import "ARSync+TestsExtension.h"

SpecBegin(ARSlugResolver);

describe(@"resolving albums", ^{
    __block Album *downloadedAlbum, *localAlbum, *localFilledAlbum;
    __block Artist *artist;
    __block Artwork *artwork1, *artwork2, *artwork3;
    __block Partner *partner;

    __block NSManagedObjectContext *context;
    __block NSInteger preAlbumCount;
    __block NSArray *allAlbums;

    beforeAll(^{
        context = [CoreDataManager stubbedManagedObjectContext];
        artist = [Artist objectInContext:context];
        NSArray *slugs = @[ @"slug1", @"slug2" ];
        partner = [Partner createInContext:context];

        artwork1 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork1.slug = slugs[0];
        artwork1.artist = artist;

        artwork2 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork2.slug = slugs[1];
        artwork2.artist = artist;

        artwork3 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork3.artist = artist;

        downloadedAlbum = [Album objectInContext:context];
        downloadedAlbum.artworkSlugs = [NSSet setWithArray:slugs];
        downloadedAlbum.editable = @(NO);

        localAlbum = [Album objectInContext:context];
        localAlbum.artworkSlugs = [NSSet setWithArray:slugs];
        localAlbum.editable = @(YES);

        localFilledAlbum = [Album objectInContext:context];
        localFilledAlbum.artworks = [NSSet setWithArray:@[ artwork1 ]];
        localFilledAlbum.editable = @(YES);

        preAlbumCount = [Album countInContext:context error:nil];

        ARSlugResolver *resolver = [[ARSlugResolver alloc] init];

        ARSync *sync = [ARSync syncForTesting:context];
        [resolver syncDidFinish:sync];

        allAlbums = [Album findAllInContext:context];

    });

    it(@"sets artworks from slugs", ^{
        expect(downloadedAlbum.artworks).to.contain(artwork1);
        expect(downloadedAlbum.artworks).to.contain(artwork2);
        expect(downloadedAlbum.artworks).toNot.contain(artwork3);
    });

    it(@"does not set the artworks for local albums", ^{
        expect(localAlbum.artworks.count).to.equal(0);
    });

    it(@"creates an all artworks album", ^{
        NSInteger postAlbumCount = [Album countInContext:context error:nil];
        expect(preAlbumCount).to.beLessThan(postAlbumCount);
    });

    it(@"contains an all artworks album", ^{
        Album *allArtworksAlbum = [Album findFirstByAttribute:@"slug" withValue:@"all_artworks" inContext:context];
        expect(allArtworksAlbum).to.beTruthy();
    });

    it(@"does not create a for sale album if there are no for sale artworks", ^{
        Album *forSaleAlbum = [Album findFirstByAttribute:@"slug" withValue:@"for_sale_works" inContext:context];
        expect(forSaleAlbum).to.beFalsy();
    });

    it(@"contains a for sale album with only for sale artworks", ^{
        artwork2.isAvailableForSale = @YES;

        ARSlugResolver *resolver = [[ARSlugResolver alloc] init];
        ARSync *sync = [ARSync syncForTesting:context];
        [resolver syncDidFinish:sync];

        Album *forSaleAlbum = [Album findFirstByAttribute:@"slug" withValue:@"for_sale_works" inContext:context];
        expect(forSaleAlbum.artworks).to.contain(artwork2);
    });

    it(@"updates album artists", ^{
        // It's expected that this won't get its artworks set
        // thus no artists to be generated.
        expect(localAlbum.artists.count).to.equal(0);

        expect(localFilledAlbum.artists.count).to.equal(1);
        expect(downloadedAlbum.artists.count).to.equal(1);
    });

    it(@"does not set the album artists for all artworks", ^{
        Album *allAartworksAlbum = [Album createOrFindAlbumInContext:context slug:@"all_artworks"];
        expect(allAartworksAlbum.artists.count).to.equal(0);
    });

});

describe(@"resolving shows", ^{
    it(@"sets artworks from slugs", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        NSArray *slugs = @[ @"slug1", @"slug2" ];
        Artist *artist = [Artist objectInContext:context];

        Artwork *artwork = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork.slug = slugs[0];
        artwork.artist = artist;

        Artwork *artwork2 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork2.slug = slugs[1];
        artwork2.artist = artist;

        Artwork *artwork3 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork3.artist = artist;

        Show *show = [Show objectInContext:context];
        show.artworkSlugs = [NSSet setWithArray:slugs];

        ARSlugResolver *resolver = [[ARSlugResolver alloc] init];
        ARSync *sync = [ARSync syncForTesting:context];
        [resolver syncDidFinish:sync];

        expect(show.artworks).to.contain(artwork);
        expect(show.artworks).to.contain(artwork2);
        expect(show.artworks).toNot.contain(artwork3);

        expect(show.artists.count).to.equal(1);
    });
});

describe(@"resolving locations", ^{
    it(@"sets artworks from slugs", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        NSArray *slugs = @[ @"slug1", @"slug2" ];

        Artwork *artwork = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork.slug = slugs[0];

        Artwork *artwork2 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork2.slug = slugs[1];

        Location *location = [Location objectInContext:context];
        location.artworkSlugs = [NSSet setWithArray:slugs];

        ARSlugResolver *resolver = [[ARSlugResolver alloc] init];
        ARSync *sync = [ARSync syncForTesting:context];
        [resolver syncDidFinish:sync];

        expect(location.artworks).to.contain(artwork);
        expect(location.artworks).to.contain(artwork2);
    });
});

SpecEnd

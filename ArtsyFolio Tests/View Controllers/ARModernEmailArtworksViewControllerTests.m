#import "ARModernEmailArtworksViewController.h"
#import "AREmailSettings.h"
#import "ARThumbnailImageSelectionView.h"
#import "InstallShotImage.h"
#import "LocalImage.h"


@interface ARModernEmailArtworksViewController (Private)
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (readwrite, strong, nonatomic) ARThumbnailImageSelectionView *additionalImagesSelectionView;
@property (readwrite, strong, nonatomic) ARThumbnailImageSelectionView *installationShotsSelectionView;
@end


SpecBegin(ARModernEmailArtworksViewController);

__block NSArray *artworks, *documents;
__block ARModernEmailArtworksViewController *subject;
__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
});

// Should be the same regardless of white/black folio
// and as it's a popover, no point in iPad specific support

it(@"email popovers", ^{
    Document *document = [Document objectInContext:context];
    document.hasFile = @YES;
    document.title = @"document";

    Artist *artist = [Artist objectInContext:context];
    artist.name = @"an artist";
    artist.documents = [NSSet setWithObject:document];

    Artwork *artwork = [Artwork objectInContext:context];
    artwork.artists = [NSSet setWithObject:artist];

    // A show
    Show *show = [Show objectInContext:context];
    show.name = @"Show";
    Artwork *artwork2 = [Artwork objectInContext:context];
    show.artworks = [NSSet setWithObject:artwork2];

    artworks = @[ artwork, artwork2 ];

    [ARTestContext useContext:ARTestContextDeviceTypePhone5:^{

        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:artworks documents:documents installShots:@[] context:artist];
        expect(subject).to.haveValidSnapshotNamed(@"with artworks + show");

        InstallShotImage *image = [InstallShotImage objectInContext:context];
        show.installationImages = [NSSet setWithObject:image];

        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:artworks documents:documents installShots:@[] context:show];
        expect(subject).to.haveValidSnapshotNamed(@"show context with install shots");

        show.documents = [NSSet setWithObject:document];
        documents = @[ document ];

        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:artworks documents:documents installShots:@[] context:artist];
        expect(subject).to.haveValidSnapshotNamed(@"with documents");

        artwork.series = @"Series";
        artwork.provenance = @"Provenance";
        artwork.inventoryID = @"Inventory";
        artwork.displayPrice = @"$$$";

        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:artworks documents:documents installShots:@[] context:artist];
        expect(subject).to.haveValidSnapshotNamed(@"with artwork metadata");

        NSArray *images = @[ [LocalImage objectInContext:context], [LocalImage objectInContext:context] ];
        artwork.images = [NSSet setWithArray:images];
        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:artworks documents:documents installShots:@[] context:artist];
        expect(subject).to.haveValidSnapshotNamed(@"additional images");

        Artwork *artwork2 = [Artwork objectInContext:context];
        images = @[ [LocalImage objectInContext:context], [LocalImage objectInContext:context] ];
        artwork2.images = [NSSet setWithArray:images];
        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:@[ artwork2 ] documents:nil installShots:@[] context:artist];
        expect(subject).to.haveValidSnapshotNamed(@"additional images with no artwork metadata");

        Artwork *artwork3 = [Artwork objectInContext:context];
        artwork3.displayPrice = @"price";
        artwork3.backendPrice = @"backend price";
        images = @[ [LocalImage objectInContext:context], [LocalImage objectInContext:context] ];
        artwork2.images = [NSSet setWithArray:images];
        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:@[ artwork3 ] documents:nil installShots:@[] context:artist];
        expect(subject).to.haveValidSnapshotNamed(@"shows exact prices when available");

    }];
});

describe(@"email settings object", ^{
    __block ForgeriesUserDefaults *defaults;

    before(^{
        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:nil documents:nil installShots:@[] context:nil];
        subject.userDefaults = (id)[[ForgeriesUserDefaults alloc] init];
        defaults = (id)subject.userDefaults;
    });

    it(@"handle Supplementary Information correct", ^{
        expect([subject.emailSettings showSupplementaryInformation]).to.beFalsy();

        defaults[@"ARMailShowSupplementary InformationDefault"] = @YES;
        expect([subject.emailSettings showSupplementaryInformation]).to.beTruthy();
    });

    it(@"handle Inventory ID correct", ^{
        defaults[@"ARMailShowInventory IDDefault"] = @YES;
        expect([subject.emailSettings showInventoryID]).to.beTruthy();

        defaults[@"ARMailShowInventory IDDefault"] = @NO;
        expect([subject.emailSettings showInventoryID]).to.beFalsy();
    });

    it(@"handle Price correct", ^{
        defaults[@"ARMailShowPrice TypeDefault"] = @1;
        expect([subject.emailSettings showPrice]).to.beTruthy();

        defaults[@"ARMailShowPrice TypeDefault"] = @0;
        expect([subject.emailSettings showPrice]).to.beFalsy();
    });

    describe(@"with no artworks having public details", ^{
        it(@"handle Exact Price correct", ^{
            defaults[@"ARMailShowPrice TypeDefault"] = @1;
            expect([subject.emailSettings showBackendPrice]).to.beTruthy();

            defaults[@"ARMailShowPrice TypeDefault"] = @0;
            expect([subject.emailSettings showBackendPrice]).to.beFalsy();
        });
    });
    describe(@"with artworks also having public details", ^{
        before(^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.displayPrice = @"111";

            subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:@[ artwork ] documents:nil installShots:@[] context:nil];
            subject.userDefaults = (id)[[ForgeriesUserDefaults alloc] init];
            defaults = (id)subject.userDefaults;
        });

        it(@"handles exact prices right", ^{
            defaults[@"ARMailShowPrice TypeDefault"] = @2;
            expect([subject.emailSettings showBackendPrice]).to.beTruthy();

            defaults[@"ARMailShowPrice TypeDefault"] = @1;
            expect([subject.emailSettings showBackendPrice]).to.beFalsy();

            defaults[@"ARMailShowPrice TypeDefault"] = @0;
            expect([subject.emailSettings showBackendPrice]).to.beFalsy();
        });
    });

});

describe(@"passing objects", ^{

    __block ForgeriesUserDefaults *defaults;
    __block InstallShotImage *image, *mainImage, *additionalImage;
    __block Artwork *artwork, *artwork2;

    before(^{
        Document *document = [Document objectInContext:context];
        document.slug = @"TEST";
        document.hasFile = @YES;

        Artist *artist = [Artist objectInContext:context];
        artist.documents = [NSSet setWithObject:document];
        artwork = [Artwork objectInContext:context];
        artwork.artist = artist;

        Show *show = [Show objectInContext:context];
        show.documents = [NSSet setWithObject:document];

        artwork2 = [Artwork objectInContext:context];
        show.artworks = [NSSet setWithObject:artwork2];

        mainImage = [Image objectInContext:context];
        mainImage.mainImageForArtwork = artwork2;
        additionalImage = [Image objectInContext:context];
        artwork2.images = [NSSet setWithObjects:mainImage, additionalImage, nil];

        image = [InstallShotImage objectInContext:context];
        show.installationImages = [NSSet setWithObject:image];

        artworks = @[ artwork, artwork2 ];
        documents = @[ document ];

        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:artworks documents:documents installShots:@[] context:nil];
        subject.userDefaults = (id)[[ForgeriesUserDefaults alloc] init];
        defaults = (id)subject.userDefaults;
    });

    it(@"passes along selected artworks", ^{
        expect(subject.emailSettings.artworks).to.equal(artworks);
    });

    it(@"passes along selected documents", ^{
        expect(subject.emailSettings.documents).toNot.equal(documents);

        defaults[@"ARMailIncludeFileTESTDefault"] = @YES;
        expect(subject.emailSettings.documents).to.equal(documents);
    });

    describe(@"passes along", ^{
        __block ARThumbnailImageSelectionView *selection;

        before(^{
            LocalImage *image = [LocalImage objectInContext:context];
            NSString *localImagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"example-image" ofType:@"png"];
            image.imageFilePath = localImagePath;

            selection = [[ARThumbnailImageSelectionView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            [selection setImages:@[ image ]];
            [selection selectAll];
        });

        it(@"selected install shots", ^{
            subject.installationShotsSelectionView = selection;
            expect(subject.emailSettings.installationShots).to.contain(image);
        });

        it(@"selected additional images", ^{
            subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:@[ artwork2 ] documents:nil installShots:@[] context:nil];
            subject.additionalImagesSelectionView = selection;

            expect(subject.emailSettings.additionalImages).to.contain(additionalImage);
            expect(subject.emailSettings.additionalImages).toNot.contain(mainImage);
        });

    });
});

describe(@"incoming selection state", ^{
    __block ForgeriesUserDefaults *defaults;

    it(@"ensures doc selection state is retained", ^{

        Document *document = [Document objectInContext:context];
        document.slug = @"ExampleDocument";
        document.hasFile = @YES;

        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:@[] documents:@[ document ] installShots:@[] context:nil];
        subject.userDefaults = (id)[[ForgeriesUserDefaults alloc] init];
        defaults = (id)subject.userDefaults;

        expect(defaults[@"ARMailIncludeFileExampleDocumentDefault"]).to.beFalsy();

        [subject beginAppearanceTransition:YES animated:NO];

        expect(defaults[@"ARMailIncludeFileExampleDocumentDefault"]).to.beTruthy();
    });

    it(@"ensures install selection state is retained", ^{

        InstallShotImage *image = [InstallShotImage objectInContext:context];
        image.slug = @"InstallImageSlug";
        subject = [[ARModernEmailArtworksViewController alloc] initWithArtworks:@[] documents:@[] installShots:@[ image ] context:nil];
        subject.userDefaults = (id)[[ForgeriesUserDefaults alloc] init];
        defaults = (id)subject.userDefaults;

        expect(defaults[@"ARMailShowInstallImageSlugDefault"]).to.beFalsy();

        [subject beginAppearanceTransition:YES animated:NO];

        expect(defaults[@"ARMailShowInstallImageSlugDefault"]).to.beTruthy();
    });

});


SpecEnd

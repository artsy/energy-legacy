#import "Album.h"
#import "Artist.h"
#import "AREditAlbumViewController.h"
#import "ModelStubs.h"
#import "ARSelectionHandler.h"
#import "NSFetchRequest+ARModels.h"
#import "ARBorderedSerifLabel.h"
#import <Artsy_UILabels/ARLabelSubclasses.h>
#import "ARAlbumEditNavigationController.h"
#import "AROptions.h"

id ARAlbumViewControllerWithStubbedNavItem(void);
id ARAlbumViewControllerWithStubbedParent(void);


@interface AREditAlbumViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) id selectionHandler;
@property (nonatomic, assign) NSInteger initialArtworksCount;
@property (readonly, nonatomic, strong) ARBorderedSerifLabel *phoneTitleLabel;

- (void)updateTitle;
- (void)updateSubtitleAnimated:(BOOL)animated;
@end

SpecBegin(AREditAlbumViewController);

__block AREditAlbumViewController *editVC;
__block NSManagedObjectContext *context;

describe(@"on init", ^{

    it(@"accepts an album", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        Album *album = [Album createInContext:context];
        AREditAlbumViewController *editVC = [[AREditAlbumViewController alloc] initWithAlbum:album];
        expect(editVC.album).to.equal(album);
    });

    it(@"cannot be initialized without an album", ^{
        expect(^{
            id something = [[AREditAlbumViewController alloc] initWithAlbum:nil];
            something = nil;
        }).to.raiseAny();
    });
});

describe(@"visuals", ^{
    __block Artwork *artwork;
    __block Album *album;
    
    dispatch_block_t before = ^{
        context  = [CoreDataManager stubbedManagedObjectContext];
        artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        Image *image = [Image objectInContext:context];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AROptionsUseWhiteFolio];

        album = [Album objectInContext:context];
        album.name = @"Test";
        
        Artist *artist = [ARModelFactory filledArtistInContext:context];
        artist.artworks = [NSSet setWithObject:artwork];
        artwork.mainImage = image;
        
        ARAlbumEditNavigationController *navController = [[ARAlbumEditNavigationController alloc] initWithAlbum:album];
        editVC = [[AREditAlbumViewController alloc] initWithAlbum:album];
        [navController setViewControllers:@[editVC] animated:NO];
    };
    
    itHasSnapshotsForDevices(@"default", ^{
        before();
        return editVC.navigationController;
    });
    
    
    itHasSnapshotsForDevices(@"with existing album", ^{
        before();
        album.artworks = [NSSet setWithObject:artwork];
        return editVC.navigationController;
    });
    
    itHasSnapshotsForDevices(@"with existing items selected", ^{
        before();

        ARSelectionHandler *handler = [[ARSelectionHandler alloc] init];
        editVC.selectionHandler = handler;

        // It will reset the selection handling, if done after below
        [editVC beginAppearanceTransition:YES animated:NO];
        [editVC endAppearanceTransition];

        [handler selectObject:artwork];
        
        return editVC.navigationController;
    });

});

describe(@"data interactions", ^{
    __block Album *album;
    __block Artist *artist;

    beforeEach(^{
        context = [CoreDataManager stubbedManagedObjectContext];
        artist = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];

        album = [Album stubbedAlbumWithPublishedArtworks:YES inContext:context];
        editVC = [[AREditAlbumViewController alloc] initWithAlbum:album];
        editVC.defaults = (id)[ForgeriesUserDefaults defaults:@{}];

        [editVC beginAppearanceTransition:YES animated:NO];
        [editVC endAppearanceTransition];
    });

    it(@"has a cell for each available artist", ^{
        NSInteger rowCount = [editVC tableView:editVC.tableView numberOfRowsInSection:0];
        expect(rowCount).to.equal(1);
    });

    it(@"tapping a cell opens pushes a view controller", ^{
        OCMockObject *mockItem = [OCMockObject niceMockForClass:UINavigationController.class];
        id prartialEdit = [OCMockObject partialMockForObject:editVC];
        [[[prartialEdit stub] andReturn:mockItem] navigationController];

        [[mockItem expect] pushViewController:[OCMArg any] animated:YES];

        NSIndexPath *zeroPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [prartialEdit tableView:editVC.tableView didSelectRowAtIndexPath:zeroPath];

        [mockItem verify];
    });
});

describe(@"title", ^{
    beforeEach(^{
        editVC = ARAlbumViewControllerWithStubbedParent();
        editVC.selectionHandler = (id)[OCMockObject niceMockForClass:ARSelectionHandler.class];
    });

    it(@"says album name in title", ^{
        [editVC updateTitle];
        expect(editVC.title).to.contain(editVC.album.name.uppercaseString);
    });
});

pending(@"subtitle", ^{
    beforeEach(^{
        editVC = ARAlbumViewControllerWithStubbedParent();
        editVC.selectionHandler = (id)[OCMockObject niceMockForClass:ARSelectionHandler.class];
        [editVC beginAppearanceTransition:YES animated:NO];
        [editVC endAppearanceTransition];
    });
    
    it(@"says item when only one item is selected", ^{
        [[[editVC.selectionHandler stub] andReturn:@[@1]] selectedObjects];
        [editVC updateSubtitleAnimated:NO];
        
        NSString *subtitle = editVC.phoneTitleLabel.label.text;
        expect(subtitle).toNot.contain(@"ITEMS");
        expect(subtitle).to.contain(@"ITEM");
    });
    
    it(@"says items when more than one item is selected", ^{
        [[[editVC.selectionHandler stub] andReturn:@[@1, @2]] selectedObjects];
        [editVC updateTitle];
        
        NSString *subtitle = editVC.phoneTitleLabel.label.text;
        expect(subtitle).to.contain(@"ITEMS");
    });
    
    it(@"says remove when there are items being removed", ^{
        [[[editVC.selectionHandler stub] andReturn:@[@1, @2]] selectedObjects];
        editVC.initialArtworksCount = 3;
        
        [editVC updateSubtitleAnimated:NO];
        
        NSString *subtitle = editVC.phoneTitleLabel.label.text;
        expect(subtitle).to.contain(@"REMOVE");
    });
    
    it(@"says add when there are items being added", ^{
        [[[editVC.selectionHandler stub] andReturn:@[@1, @2]] selectedObjects];
        
        [editVC updateSubtitleAnimated:NO];
        
        NSString *subtitle = editVC.phoneTitleLabel.label.text;
        expect(subtitle).to.contain(@"ADD");
    });
});


SpecEnd

    id
    ARAlbumViewControllerWithStubbedNavItem(void)
{
    OCMockObject *mockItem = [OCMockObject niceMockForClass:UINavigationItem.class];
    NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];

    Album *album = [Album createInContext:context];
    AREditAlbumViewController *topVC = [[AREditAlbumViewController alloc] initWithAlbum:album];
    id partialTopVC = [OCMockObject partialMockForObject:topVC];
    [[[partialTopVC stub] andReturn:mockItem] navigationItem];

    return partialTopVC;
};

id ARAlbumViewControllerWithStubbedParent(void)
{
    OCMockObject *mockController = [OCMockObject niceMockForClass:UIViewController.class];
    NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];

    Album *album = [Album createInContext:context];
    album.name = @"Eigen";
    AREditAlbumViewController *albumVC = [[AREditAlbumViewController alloc] initWithAlbum:album];

    id partialTopVC = [OCMockObject partialMockForObject:albumVC];
    [[[partialTopVC stub] andReturn:mockController] parentViewController];

    return partialTopVC;
};

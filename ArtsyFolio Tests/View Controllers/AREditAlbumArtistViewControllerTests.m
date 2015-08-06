#import "AREditAlbumArtistViewController.h"
#import "ARAlbumEditNavigationController.h"
#import "ARSelectionHandler.h"
#import "AROptions.h"


@interface AREditAlbumArtistViewController ()
@property (nonatomic, strong) ARSelectionHandler *selectionHandler;
@end

SpecBegin(AREditAlbumArtistViewController);

__block AREditAlbumArtistViewController *sut;
__block Artwork *artwork;
__block Album *album;
__block Artist *artist;

__block NSManagedObjectContext *context;

before(^{
    sut = [[AREditAlbumArtistViewController alloc] init];
});

describe(@"setup", ^{
    __block NSManagedObjectContext *context;
    __block id partialEditVC;
    
    beforeEach(^{
        [ARTestContext setContext:ARTestContextDeviceTypePad];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AROptionsUseWhiteFolio];

        context = [CoreDataManager stubbedManagedObjectContext];
        artist = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
        
        sut = [[AREditAlbumArtistViewController alloc] initWithArtist:artist];
        partialEditVC = [OCMockObject partialMockForObject:sut];
    });

    after(^{
        [ARTestContext endContext];
    });
    
    it(@"has nothing selected this session when set up", ^{
        expect(sut.selectedInThisSessionCount).to.equal(0);
    });
    
    it(@"selecting artworks this session changes the count", ^{
        Artwork *artwork = artist.artworks.anyObject;
        
        expect(sut.selectedInThisSessionCount).to.equal(0);
        [sut gridView:nil didSelectItem:artwork atIndex:0];
        
        expect(sut.selectedInThisSessionCount).to.equal(1);
        [sut gridView:nil didDeselectItem:artwork atIndex:0];
        
        expect(sut.selectedInThisSessionCount).to.equal(0);
    });
    
    
    it(@"adds navigation buttons for save & select all", ^{
        
        OCMockObject *mockItem = [OCMockObject niceMockForClass:UINavigationItem.class];
        [[[partialEditVC stub] andReturn:mockItem] navigationItem];
        [[mockItem expect] setRightBarButtonItems:[OCMArg any]];
        
        [partialEditVC viewWillAppear:NO];
        [mockItem verify];
    });
    
    it(@"save pops the nav back", ^{
        OCMockObject *mockItem = [OCMockObject niceMockForClass:UINavigationController.class];
        [[[partialEditVC stub] andReturn:mockItem] navigationController];
        [[mockItem expect] popViewControllerAnimated:YES];
        
        [partialEditVC saveChanges];
        [mockItem verify];
    });
});


describe(@"visuals", ^{
    
    dispatch_block_t before = ^{
        context  = [CoreDataManager stubbedManagedObjectContext];
        artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        Image *image = [Image objectInContext:context];
        
        album = [Album objectInContext:context];
        album.name = @"Test";
        
        artist = [ARModelFactory filledArtistInContext:context];
        artist.artworks = [NSSet setWithObject:artwork];
        artwork.mainImage = image;

        ARAlbumEditNavigationController *navController = [[ARAlbumEditNavigationController alloc] initWithAlbum:album];
        sut = [[AREditAlbumArtistViewController alloc] initWithArtist:artist];
        [navController setViewControllers:@[sut] animated:NO];

    };
    
    itHasSnapshotsForDevices(@"default", ^{
        before();
        return sut.navigationController;
    });
    
    
    itHasSnapshotsForDevices(@"with existing album", ^{
        before();
        album.artworks = [NSSet setWithObject:artwork];
        return sut.navigationController;
    });
    
    itHasSnapshotsForDevices(@"with existing items selected", ^{
        before();
        
        // It will reset the selection handling, if done after below
        [sut beginAppearanceTransition:YES animated:NO];
        [sut endAppearanceTransition];
        [sut deselectAllItems];
        
        [sut selectItem:artwork];
        
        return sut.navigationController;
    });

});


SpecEnd

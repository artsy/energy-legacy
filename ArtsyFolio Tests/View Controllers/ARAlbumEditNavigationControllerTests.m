#import "ARAlbumEditNavigationController.h"
#import "ARSelectionHandler.h"


@interface ARAlbumEditNavigationController (DI)
@property (nonatomic, strong) ARSelectionHandler *selectionHandler;
@end

SpecBegin(ARAlbumEditNavigationController);

__block ARAlbumEditNavigationController *sut;
__block OCMockObject *mockController;
__block NSManagedObjectContext *context;

describe(@"interaction buttons", ^{
    
    before(^{
        context = [CoreDataManager stubbedManagedObjectContext];
        
        Album *album = [Album createInContext:context];
        album.name = @"Eigen";

        mockController = [OCMockObject niceMockForClass:UIViewController.class];
        sut = [[ARAlbumEditNavigationController alloc] initWithAlbum:album];
        OCMockObject *sutMock = [OCMockObject partialMockForObject:sut];
        [[[sutMock stub] andReturn: mockController] presentingViewController];
    });
    
    it(@"pops modal on save", ^{
        [[mockController expect] dismissViewControllerAnimated:YES completion:nil];
        [sut saveAlbum];

        [mockController verify];
    });

    it(@"pops the modal on cancel", ^{
        [[mockController expect] dismissViewControllerAnimated:NO completion:[OCMArg any]];
        [sut cancelEditingAlbumAnimated:NO];

        [mockController verify];
    });

});

describe(@"deletion", ^{
    before(^{
        context = [CoreDataManager stubbedManagedObjectContext];

        Album *album = [Album createInContext:context];
        album.name = @"Eigen";

        sut = [[ARAlbumEditNavigationController alloc] initWithAlbum:album];
    });


    pending(@"doesn't delete album on cancel when it is not empty", ^{
        sut.album.artworks = [NSSet setWithObject:[Artwork stubbedArtworkWithImages:NO inContext:context]];

        ARSelectionHandler *handler = [[ARSelectionHandler alloc] init];
        sut.selectionHandler = handler;
        [handler startSelectingForAlbum:sut.album];
        
        [sut cancelEditingAlbumAnimated:NO];

        expect([Album countInContext:context error:nil]).to.equal(1);
    });
});

describe(@"wording", ^{
    before(^{
        context = [CoreDataManager stubbedManagedObjectContext];
        Album *album = [Album createInContext:context];
        album.name = @"Eigen";

        ARSelectionHandler *handler = [[ARSelectionHandler alloc] init];
        sut.selectionHandler = handler;

        sut = [[ARAlbumEditNavigationController alloc] initWithAlbum:album];
    });

    it(@"returns nil when no changes from inital album state", ^{
        Artwork *artwork = [Artwork stubbedArtworkWithImages:NO inContext:context];
        sut.album.artworks = [NSSet setWithObject:artwork];

        [sut.selectionHandler startSelectingForAlbum:sut.album];

        expect(sut.descriptionOfSelectionState).to.beNil;
    });

    it(@"shows added when there's 1 artwork in the selection handler", ^{
        Artwork *artwork = [Artwork stubbedArtworkWithImages:NO inContext:context];
        sut.album.artworks = [NSSet setWithObject:artwork];

        [sut.selectionHandler startSelectingForAlbum:sut.album];

        Artwork *artwork2 = [Artwork stubbedArtworkWithImages:NO inContext:context];
        [sut.selectionHandler selectObject:artwork2];

        expect(sut.descriptionOfSelectionState).to.equal(@"1 ITEM TO ADD");
    });

    it(@"shows removed when there's 1 artwork less in the selection handler", ^{
        Artwork *artwork = [Artwork stubbedArtworkWithImages:NO inContext:context];
        sut.album.artworks = [NSSet setWithObject:artwork];

        [sut.selectionHandler startSelectingForAlbum:sut.album];
        [sut.selectionHandler deselectObject:artwork];

        expect(sut.descriptionOfSelectionState).to.equal(@"1 ITEM TO REMOVE");
    });

    it(@"shows add 1, removed 1 when something was removed and something added", ^{
        Artwork *artwork = [Artwork stubbedArtworkWithImages:NO inContext:context];
        sut.album.artworks = [NSSet setWithObject:artwork];

        [sut.selectionHandler startSelectingForAlbum:sut.album];
        [sut.selectionHandler deselectObject:artwork];

        Artwork *artwork2 = [Artwork stubbedArtworkWithImages:NO inContext:context];
        [sut.selectionHandler selectObject:artwork2];

        expect(sut.descriptionOfSelectionState).to.equal(@"ADD 1, REMOVE 1");
    });

});


SpecEnd

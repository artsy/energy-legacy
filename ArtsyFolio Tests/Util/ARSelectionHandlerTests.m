#import "Album.h"
#import "ARSelectionHandler.h"

SpecBegin(ARSelectionHandlerTests);

__block NSManagedObjectContext *context;
__block ARSelectionHandler *handler;

describe(@"when selecting", ^{
    beforeEach(^{
        handler = [[ARSelectionHandler alloc] init];
    });

    it(@"respond that it is selecting for emails", ^{
        [handler startSelectingForEmail];

        expect(handler.isSelecting).to.beTruthy();
        expect(handler.isSelectingForEmail).to.beTruthy();
        expect(handler.isSelectingForAlbum).to.beFalsy();

        [handler finishSelection];
    });

    it(@"for adding to albums", ^{
        [handler startSelectingForAnyAlbum];

        expect(handler.isSelecting).to.beTruthy();
        expect(handler.isSelectingForEmail).to.beFalsy();
        expect(handler.isSelectingForAlbum).to.beTruthy();

        [handler finishSelection];
    });

    it(@"for adding to a specific album", ^{
        Album *album = [Album objectInContext:[CoreDataManager stubbedManagedObjectContext]];
        [handler startSelectingForAlbum:album];

        expect(handler.isSelecting).to.beTruthy();
        expect(handler.isSelectingForEmail).to.beFalsy();
        expect(handler.isSelectingForAlbum).to.beFalsy();

        [handler finishSelection];
    });

    it(@"updates album artists after saving", ^{
        context = [CoreDataManager stubbedManagedObjectContext];

        Album *album = [Album objectInContext:context];
        [handler startSelectingForAlbum:album];

        Artwork *artwork = [Artwork objectInContext:context];
        Artist *artist = [Artist objectInContext:context];
        artwork.artists = [NSSet setWithObject:artist];

        [handler selectObject:artwork];
        [handler commitSelection];

        expect([album artists].count).to.equal(1);
        expect([artist albumsFeaturingArtist].count).to.equal(1);
    });

});

describe(@"notifications", ^{

    it(@"notifies on deselect", ^{
        expect(^{
            [[ARSelectionHandler sharedHandler] deselectAllObjects];
        }).to.notify(ARGridSelectionChangedNotification);
    });

    it(@"notifies on deselect", ^{
        expect(^{
            [[ARSelectionHandler sharedHandler] selectObject:[Artwork stubbedModelFromJSON:@{}]];
        }).to.notify(ARGridSelectionChangedNotification);
    });

});

SpecEnd

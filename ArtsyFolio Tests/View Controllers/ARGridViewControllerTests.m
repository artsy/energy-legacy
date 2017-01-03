#import "ARGridViewController.h"
#import "ARGridViewController+ForSubclasses.h"
#import "Location.h"
#import "ARImageGridViewItem.h"

SpecBegin(ARGridViewController);

describe(@"content sorting", ^{

    it(@"all shows should be ordered by show date", ^{
        ARGridViewController *subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeAllShows];
        subject.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
        [subject reloadContent];

        expect(subject.results.sortDescriptors).to.equal([Show sortDescriptorsForDates]);
    });

});

it(@"does not crash when setting the request manually", ^{
    NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
    Show *show = [Show objectInContext:context];
    Artist *artist = [Artist objectInContext:context];
    [show addArtistsObject:artist];

    ARGridViewController *sut = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeArtistShows];
    sut.managedObjectContext = context;
    sut.results = [artist showsFeaturingArtistFetchRequest];

    expect(^{
        [sut reloadContent];
    }).toNot.raise(nil);
});

describe(@"content", ^{
    it(@"Gets all locations when display mode is ARDisplayModeAllLocations", ^{
        ARGridViewController *subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeAllLocations];
        subject.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];

        OCMockObject *mock = [OCMockObject mockForClass:Location.class];
        [[[mock expect] classMethod] allLocationsFetchRequestInContext:OCMOCK_ANY defaults:OCMOCK_ANY];

        [subject reloadContent];

        expect(^{
            [mock verify];
        }).toNot.raise(nil);
    });
});

describe(@"allowing selection", ^{
    it(@"does not support selecting a container", ^{
        ARGridViewController *subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeArtistShows];
        expect([subject gridView:nil canSelectItem:nil atIndex:0]).to.beFalsy();

        subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeArtistAlbums];
        expect([subject gridView:nil canSelectItem:nil atIndex:0]).to.beFalsy();
    });

    it(@"supports selecting a artworks / documents / install shots", ^{
        ARGridViewController *subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeAlbum];
        expect([subject gridView:nil canSelectItem:nil atIndex:0]).to.beTruthy();

        subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeShow];
        expect([subject gridView:nil canSelectItem:nil atIndex:0]).to.beTruthy();

        subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeArtist];
        expect([subject gridView:nil canSelectItem:nil atIndex:0]).to.beTruthy();

        subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeDocuments];
        expect([subject gridView:nil canSelectItem:nil atIndex:0]).to.beTruthy();

        subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeInstallationShots];
        expect([subject gridView:nil canSelectItem:nil atIndex:0]).to.beTruthy();
    });

    it(@"does not support selecting a work when in editing mode", ^{
        ARGridViewController *subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeAllAlbums];
        [subject setIsEditing:YES animated:NO];

        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        Artwork *artwork = [Artwork objectInContext:context];
        expect([subject gridView:nil canSelectItem:artwork atIndex:0]).to.beFalsy();
    });

    it(@"does support selecting ARImageGridViewItems in editing mode", ^{
        ARGridViewController *subject = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeAllAlbums];
        [subject setIsEditing:YES animated:NO];
        ARImageGridViewItem *item = [[ARImageGridViewItem alloc] init];
        expect([subject gridView:nil canSelectItem:item atIndex:0]).to.beTruthy();
    });

});

SpecEnd

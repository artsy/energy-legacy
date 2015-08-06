#import "ARAlbumViewController.h"
#import "CoreDataManager.h"
#import "Album.h"
#import "NSManagedObject+ActiveRecord.h"
#import "ARNavigationController.h"
#import "ARSelectionToolbarView.h"

SpecBegin(ARAlbumViewController);

__block ARAlbumViewController *sut;
__block ARNavigationController *controller;

it(@"shows an edit button if it's editable", ^{
    NSManagedObjectContext *context  = [CoreDataManager stubbedManagedObjectContext];
    Album *album = [Album objectInContext:context];
    album.editable = @(YES);

    sut = [[ARAlbumViewController alloc] initWithAlbum:album];
    sut.managedObjectContext = context;

    controller = [[ARNavigationController alloc] initWithRootViewController:sut];

    [sut beginAppearanceTransition:YES animated:NO];
    [sut endAppearanceTransition];

    expect(sut.bottomToolbar.buttons.count).to.equal(1);
});


it(@"selection mode looks right", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        NSManagedObjectContext *context  = [CoreDataManager stubbedManagedObjectContext];
        Album *album = [Album stubbedAlbumWithPublishedArtworks:YES inContext:context];
        album.editable = @(YES);

        sut = [[ARAlbumViewController alloc] initWithAlbum:album];
        sut.managedObjectContext = context;

        controller = [[ARNavigationController alloc] initWithRootViewController:sut];

        [sut beginAppearanceTransition:YES animated:NO];
        [sut endAppearanceTransition];

        [sut setSelecting:YES animated:NO];
        
        expect(sut).to.haveValidSnapshot();
    }];
});


it(@"wraps long titles", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        NSManagedObjectContext *context  = [CoreDataManager stubbedManagedObjectContext];
        Album *album = [Album stubbedAlbumWithPublishedArtworks:YES inContext:context];
        album.name = @"This is a very long title: the sequel.... long title is really long; words words words words";
        
        sut = [[ARAlbumViewController alloc] initWithAlbum:album];
        sut.managedObjectContext = context;
        
        controller = [[ARNavigationController alloc] initWithRootViewController:sut];
        
        [controller beginAppearanceTransition:YES animated:NO];
        [controller endAppearanceTransition];
        
        expect(controller).to.haveValidSnapshot();
    }];
});


SpecEnd

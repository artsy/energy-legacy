#import "ARTabbedViewController.h"
#import "ARArtistViewController.h"
#import "ARNavigationController.h"

SpecBegin(ARTabbedViewController);

__block ARTabbedViewController *sut;
__block ARStubbedCoreData *context;
__block ARNavigationController *controller;

pending(@"visuals", ^{

    before(^{
        context = [ARStubbedCoreData stubbedCoreDataInstance];
    });

    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"default state", ^{

        sut = [[ARTabbedViewController alloc] initWithRepresentedObject:context.artist1];
        sut.managedObjectContext = context.context;

        return sut;
    });
    
    itRecordsViewControllerWithDevicesAndColorStates(@"showing toolbars", ^{
        
        sut = [[ARTabbedViewController alloc] initWithRepresentedObject:context.artist1];
        sut.managedObjectContext = context.context;

        [sut beginAppearanceTransition:YES animated:NO];
        [sut endAppearanceTransition];
        
        [sut showTopButtonToolbar:YES animated:NO];
        [sut showBottomButtonToolbar:YES animated:NO];
        
        return sut;
    });

});

it(@"wraps long titles", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        NSManagedObjectContext *context  = [CoreDataManager stubbedManagedObjectContext];
        Artist *artist = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
        artist.name = @"The artist formerly known as the artist formerly known as the artist formerly known as the artist";

        sut = [[ARArtistViewController alloc] initWithArtist:artist];
        sut.managedObjectContext = context;

        controller = [[ARNavigationController alloc] initWithRootViewController:sut];

        [controller beginAppearanceTransition:YES animated:NO];
        [controller endAppearanceTransition];

        expect(controller).to.haveValidSnapshot();
    }];
});

SpecEnd

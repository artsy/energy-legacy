#import "ARTopViewController.h"
#import "ARTopViewToolbarController.h"

#import "ARSync.h"
#import "Album.h"
#import "Artwork.h"
#import "ARSwitchBoard.h"
#import "NSManagedObject+ActiveRecord.h"
#import "UIBarButtonItem+toolbarHelpers.h"
#import "ARNotifications.h"
#import "ARDisplayModeConstants.h"
#import "ARBaseViewController+TransparentModals.h"
#import "ARModelFactory.h"
#import "ARNavigationController.h"
#import "UIColor+FolioColours.h"
#import "ARCMSStatusMonitor.h"


@interface ARSync (Priv)
@property (readwrite, nonatomic, getter=isSyncing) BOOL syncing;
@end


@interface ARTopViewController ()
@property (nonatomic, strong) ARTopViewToolbarController *toolbarController;
@property (nonatomic, assign) BOOL skipFadeIn;
@property (nonatomic, strong) ARSwitchBoard *switchBoard;

- (void)toggleEditModeAnimated:(BOOL)animated;
@end

// Partial stub of the topVC with a mock for the nav item.
id stubbedTopVCWithDisplayMode(enum ARDisplayMode displayMode);

// Partial stub of CMS Monitor with or without sync recommendation
id stubbedCMSMonitorWithSyncRecommendation(BOOL recommendation);

SpecBegin(ARTopViewController);

describe(@"visuals", ^{
    __block ARTopViewController *sut;
    __block ARStubbedCoreData *context;

    dispatch_block_t before = ^{
        context = [ARStubbedCoreData stubbedCoreDataInstance];
        sut = [[ARTopViewController alloc] init];
        sut.managedObjectContext = context.context;
        sut.skipFadeIn = YES;

        sut.cmsMonitor = stubbedCMSMonitorWithSyncRecommendation(NO);
    };

    // These don't look perfect yet because the edit button animates.

    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"default state", ^{
        before();
        return sut;
    });

    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"shows sync notification when cmsMonitor recommends sync", ^{
        before();

        [Partner createInContext:context.context];
        sut.cmsMonitor = stubbedCMSMonitorWithSyncRecommendation(YES);

        return sut;
    });

    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"default state for collector folio", ^{
        before();

        [Partner modelFromJSON:@{ @"type" : @"Private Collector",
                                  @"slug" : @"testing-partner" }
                     inContext:context.context];
        return sut;
    });


    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"showing edit in albums mode", ^{
        before();

        [sut setDisplayMode:ARDisplayModeAllAlbums animated:NO];
        return sut;
    });

    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"showing edit mode for albums", ^{
        before();

        [sut setDisplayMode:ARDisplayModeAllAlbums animated:NO];
        [sut toggleEditModeAnimated:NO];
        return sut;
    });

});

describe(@"state", ^{
    it(@"doesn't load in editing mode", ^{
        ARTopViewController *topVC = [[ARTopViewController alloc] init];
        topVC.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
        topVC.cmsMonitor = stubbedCMSMonitorWithSyncRecommendation(NO);
        [topVC beginAppearanceTransition:YES animated:NO];
        [topVC endAppearanceTransition];
        expect(topVC.editing).to.beFalsy();
    });
});

describe(@"toolbar", ^{

    __block ARTopViewController *topVC;
    __block id toolbarControllerMock;

    beforeAll(^{
        topVC = [[ARTopViewController alloc] init];
        topVC.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
        topVC.cmsMonitor = stubbedCMSMonitorWithSyncRecommendation(NO);
        topVC.switchBoard = [[ARSwitchBoard alloc] initWithNavigationController:nil context:topVC.managedObjectContext];

        toolbarControllerMock = [OCMockObject niceMockForClass:[ARTopViewToolbarController class]];
        topVC.toolbarController = toolbarControllerMock;
    });


    it(@"load default toolbar from with toolbar controller", ^{
        [[toolbarControllerMock expect] setupDefaultToolbarItems];

        [topVC beginAppearanceTransition:YES animated:NO];
        [topVC endAppearanceTransition];

        [toolbarControllerMock verify];
    });

    describe(@"when in albums", ^{
        before(^{
            [ARTestContext setContext:ARTestContextDeviceTypePad];
        });

        after(^{
            [ARTestContext endContext];
        });

        it(@"should default to 0 toolbar items on right and 1 on left", ^{
            id partialTopVC = stubbedTopVCWithDisplayMode(ARDisplayModeAllArtists);
            id mockNavItem = [partialTopVC navigationItem];

            /// The right side shouldn't have bar button items
            [[mockNavItem expect] setRightBarButtonItems:[OCMArg checkWithBlock:^BOOL(NSArray *array) {
                return (array.count == 0);
            }]];

            /// The left side should have the settings button
            [[mockNavItem expect] setLeftBarButtonItem:[OCMArg checkWithBlock:^BOOL(UIBarButtonItem *button) {
                return [button.accessibilityLabel isEqualToString:@"settings"];
            }]];

            ARTopViewToolbarController *toolbarController = [[ARTopViewToolbarController alloc] initWithTopVC:partialTopVC];
            [toolbarController setupDefaultToolbarItems];

            [mockNavItem verify];
        });


        it(@"should show an additional toolbar item on all albums", ^{
            id partialTopVC = stubbedTopVCWithDisplayMode(ARDisplayModeAllAlbums);
            id mockNavItem = [partialTopVC navigationItem];

            [[mockNavItem expect] setRightBarButtonItems:[OCMArg checkWithBlock:^BOOL(NSArray *array) {
                return (array.count == 1);
            }]];

            ARTopViewToolbarController *toolbarController = [[ARTopViewToolbarController alloc] initWithTopVC:partialTopVC];
            [toolbarController setupDefaultToolbarItems];

            [mockNavItem verify];
        });

        // TODO: OCMock infinite loop on the mock for class
        xit(@"shows edit button", ^{
            id mockAlbum = [OCMockObject mockForClass:Album.class];
            [[[[mockAlbum stub] classMethod] andReturnValue:OCMOCK_VALUE(2U)] count:nil];

            id partialTopVC = stubbedTopVCWithDisplayMode(ARDisplayModeAllAlbums);
            id mockNavItem = [partialTopVC navigationItem];

            [[mockNavItem expect] setRightBarButtonItems:[OCMArg checkWithBlock:^BOOL(NSArray *items) {
                if (!items.count) return NO;

                UIButton *editButton = [items[0] representedButton];
                return ([editButton.titleLabel.text isEqualToString:@"EDIT"]);
            }]];

            ARTopViewToolbarController *toolbarController = [[ARTopViewToolbarController alloc] initWithTopVC:partialTopVC];
            [toolbarController setupDefaultToolbarItems];

            [mockNavItem verify];
            [mockAlbum stopMocking];
        });

    });

});

describe(@"actions", ^{

    it(@"show the alert for setting the album name on create", ^{
        ARTopViewController *topVC = [[ARTopViewController alloc] init];
        id mockTopVC = [OCMockObject partialMockForObject:topVC];

        [[mockTopVC expect] presentTransparentModalViewController:[OCMArg any] animated:YES withAlpha:0.5];
        [mockTopVC createNewAlbum];
    });

    it(@"goes to edit album VC after a success", ^{
        OCMockObject *mockSwitch = [OCMockObject niceMockForClass:ARSwitchBoard.class];
        [[mockSwitch expect] pushEditAlbumViewController:[OCMArg any] animated:YES];

        ARTopViewController *topVC = [[ARTopViewController alloc] init];
        topVC.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
        topVC.switchBoard = (id)mockSwitch;

        [topVC modalViewController:nil didReturnStatus:ARModalAlertOK];

        [mockSwitch verify];
    });

    it(@"does not goes to edit album VC after tapping cancel", ^{
        OCMockObject *mockSwitch = [OCMockObject niceMockForClass:ARSwitchBoard.class];
        [[mockSwitch reject] pushEditAlbumViewController:[OCMArg any] animated:YES];

        ARTopViewController *topVC = [[ARTopViewController alloc] init];
        topVC.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
        topVC.switchBoard = (id)mockSwitch;

        [topVC modalViewController:nil didReturnStatus:ARModalAlertCancel];

        [mockSwitch verify];
    });
});


SpecEnd;

id stubbedCMSMonitorWithSyncRecommendation(BOOL recommendation)
{
    ARCMSStatusMonitor *cmsMonitor = [[ARCMSStatusMonitor alloc] init];
    id mockMonitor = [OCMockObject partialMockForObject:cmsMonitor];

    [[mockMonitor stub] checkCMSForUpdates:[OCMArg checkWithBlock:^BOOL(void (^block)(BOOL)) {
        block(recommendation);
        return YES;
    }]];

    return mockMonitor;
}

id stubbedTopVCWithDisplayMode(enum ARDisplayMode displayMode)
{
    OCMockObject *mockItem = [OCMockObject niceMockForClass:UINavigationItem.class];

    ARTopViewController *topVC = [[ARTopViewController alloc] init];
    topVC.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];

    id partialTopVC = [OCMockObject partialMockForObject:topVC];
    [[[partialTopVC stub] andReturnValue:OCMOCK_VALUE(displayMode)] displayMode];
    [[[partialTopVC stub] andReturn:mockItem] navigationItem];

    return partialTopVC;
}

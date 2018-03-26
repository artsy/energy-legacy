#import "ARArtworkSetViewController.h"
#import "ARModelFactory.h"
#import "SDWebImage+EasyCache.h"
#import "ARDefaults.h"
#import "AROptions.h"
#import "ARNavigationController.h"
#import <Forgeries/ForgeriesUserDefaults+Mocks.h>


@interface ARArtworkSetViewController ()
@property NSUserDefaults *defaults;
@end

SpecBegin(ARArtworkSetViewController);

__block NSManagedObjectContext *context;
__block ForgeriesUserDefaults *defaults;
__block NSFetchedResultsController *fetchResultscontroller;
__block ARArtworkSetViewController *subject;
__block ARNavigationController *navController;

beforeEach(^{
    [SDWebImageManager cacheImageNamed:@"example-image" toCacheWithAddress:@"(null)/13/-2147483648_-2147483648.jpg"];
    [SDWebImageManager cacheImageNamed:@"example-image" toCacheWithAddress:@"(null)/13/-9223372036854775808_-9223372036854775808.jpg"];

    context = [CoreDataManager stubbedManagedObjectContext];
    [ARModelFactory partiallyFilledArtworkInContext:context];
    [ARModelFactory partiallyFilledArtworkInContext:context];

    fetchResultscontroller = [Artwork allArtworksInContext:context];
    [fetchResultscontroller performFetch:nil];
});

describe(@"visuals", ^{
    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"default", ^id {

        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn : @NO }];

        return [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil defaults:(id)defaults];
    });

    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"when hiding the artwork edit button", ^id {

        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn : @YES,
                                                      ARHideArtworkEditButton : @YES }];

        return [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil defaults:(id)defaults];
    });
});

describe(@"presentation mode", ^{

    it(@"hides artwork edit button when pres mode and hide button toggles are both on", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn : @YES,
                                                      ARHideArtworkEditButton : @YES }];

        subject = [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil defaults:(id)defaults];

        navController = [[ARNavigationController alloc] initWithRootViewController:subject];

        [subject beginAppearanceTransition:YES animated:NO];

        expect(subject.navigationItem.rightBarButtonItems.count).to.equal(4);
    });

    it(@"shows artwork edit button when pres mode is on and hide button toggle is off", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn : @YES,
                                                      ARHideArtworkEditButton : @NO }];

        subject = [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil defaults:(id)defaults];

        navController = [[ARNavigationController alloc] initWithRootViewController:subject];

        [subject beginAppearanceTransition:YES animated:NO];

        expect(subject.navigationItem.rightBarButtonItems.count).to.equal(5);
    });

    it(@"shows artwork edit button when pres mode is off and hide button toggle is on", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn : @NO,
                                                      ARHideArtworkEditButton : @YES }];

        subject = [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil defaults:(id)defaults];

        navController = [[ARNavigationController alloc] initWithRootViewController:subject];

        [subject beginAppearanceTransition:YES animated:NO];

        expect(subject.navigationItem.rightBarButtonItems.count).to.equal(5);
    });
});

SpecEnd

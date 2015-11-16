#import "ARArtworkSetViewController.h"
#import "ARModelFactory.h"
#import "SDWebImage+EasyCache.h"
#import "ARDefaults.h"
#import "AROptions.h"
#import "ARNavigationController.h"


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
    
    context = [CoreDataManager stubbedManagedObjectContext];
    [ARModelFactory partiallyFilledArtworkInContext:context];
    [ARModelFactory partiallyFilledArtworkInContext:context];
    
    fetchResultscontroller = [Artwork allArtworksInContext:context];
    [fetchResultscontroller performFetch:nil];
});

describe(@"visuals", ^{
    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"default", ^id {
    
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @NO,
                                                      AROptionsUseLabSettings: @YES
                                                    }];
        
        subject = [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil withDefaults:(id)defaults];
        
        return subject;
    });

    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"when hiding the artwork edit button", ^id {

        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @YES,
                                                      ARHideArtworkEditButton: @YES,
                                                      AROptionsUseLabSettings: @YES
                                                    }];
        
        subject = [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil withDefaults:(id)defaults];

        return subject;
    });
});

describe(@"presentation mode", ^{

    it(@"hides artwork edit button when pres mode and hide button toggles are both on", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @YES,
                                                      ARHideArtworkEditButton: @YES,
                                                      AROptionsUseLabSettings: @YES
                                                   }];
        
        subject = [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil withDefaults:(id)defaults];
        
        navController = [[ARNavigationController alloc] initWithRootViewController:subject];
        
        [subject viewWillAppear:NO];
        
        expect(subject.navigationItem.rightBarButtonItems.count).to.equal(4);
    });
    
    it(@"shows artwork edit button when pres mode is on and hide button toggle is off", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @YES,
                                                      ARHideArtworkEditButton: @NO,
                                                      AROptionsUseLabSettings: @YES
                                                      }];
        
        subject = [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil withDefaults:(id)defaults];
        
        navController = [[ARNavigationController alloc] initWithRootViewController:subject];
        
        [subject viewWillAppear:NO];
        
        expect(subject.navigationItem.rightBarButtonItems.count).to.equal(5);
    });

    it(@"shows artwork edit button when pres mode is off and hide button toggle is on", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @NO,
                                                      ARHideArtworkEditButton: @YES,
                                                      AROptionsUseLabSettings: @YES
                                                      }];
        
        subject = [[ARArtworkSetViewController alloc] initWithArtworks:fetchResultscontroller atIndex:0 representedObject:nil withDefaults:(id)defaults];
        
        navController = [[ARNavigationController alloc] initWithRootViewController:subject];
        
        [subject viewWillAppear:NO];
        
        expect(subject.navigationItem.rightBarButtonItems.count).to.equal(5);
    });
});

SpecEnd

#import "ARLabSettingsSyncViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARSyncStatusViewModel.h"
#import "SyncLog.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "ARStubbedNetworkQualityIndicator.h"


@interface ARLabSettingsSyncViewController ()
@property (nonatomic, strong) ARSyncStatusViewModel *viewModel;
- (void)updateSubviewsAnimated:(BOOL)animated;
@end


@interface ARSyncStatusViewModel ()
- (instancetype)initWithSync:(ARSync *)sync context:(NSManagedObjectContext *)context qualityIndicator:(ARNetworkQualityIndicator *)qualityIndicator;
@end

SpecBegin(ARLabSettingsSyncViewController);

__block NSManagedObjectContext *context;
__block UIStoryboard *storyboard;
__block ARLabSettingsSyncViewController *subject;
__block UINavigationController *navController;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
});

after(^{
    [Expecta setUsesDrawViewHierarchyInRect:NO];
});

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [storyboard instantiateViewControllerWithIdentifier:SyncSettingsViewController];
    
    subject.viewModel = [[ARSyncStatusViewModel alloc] initWithSync:nil context:context qualityIndicator:[[ARStubbedNetworkQualityIndicator alloc] init]];
    
    navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
    [navController pushViewController:subject animated:NO];
});

describe(@"viewing sync records", ^{
    beforeEach(^{
        subject.viewModel.networkQuality = ARNetworkQualityGood;
    });
    
    it(@"looks right with no previous syncs", ^{
        expect(navController).to.haveValidSnapshot ();
    });
    
    /// If the test device context is changed, it must instantiate a new navController from the storyboard or it won't size properly
    itHasSnapshotsForDevices(@"looks right with existing sync records", ^{
        /// This bool tells FBSnapshotTestCase to use size classes; unfortunately, the navigation bar on iPhone looks kind of strange in the snapshots but the actual SyncSettingsViewController looks as it should
        [Expecta setUsesDrawViewHierarchyInRect:YES];

        navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
        [navController pushViewController:subject animated:NO];
        
        SyncLog *syncLog = [SyncLog objectInContext:context];
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        syncLog.dateStarted = [formatter dateFromString:@"2015-10-31T02:22:22"];
        
        SyncLog *syncLog1 = [SyncLog objectInContext:context];
        syncLog1.dateStarted = [formatter dateFromString:@"2015-11-17T02:22:22"];
        
        [subject beginAppearanceTransition:YES animated:NO];
        [navController beginAppearanceTransition:YES animated:NO];
        
        [navController.view traitCollectionDidChange:navController.view.traitCollection];
        return navController;
    });

});

describe(@"responding to network changes", ^{
    
    it(@"looks right with good network quality", ^{
        subject.viewModel.networkQuality = ARNetworkQualityGood;
        [subject beginAppearanceTransition:YES animated:NO];
        [subject updateSubviewsAnimated:NO];
        expect(navController).to.haveValidSnapshot ();
    });
    
    itHasSnapshotsForDevices(@"looks right with poor network quality", ^{
        [Expecta setUsesDrawViewHierarchyInRect:YES];

        navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
        [navController pushViewController:subject animated:NO];

        subject.viewModel.networkQuality = ARNetworkQualitySlow;
        [subject beginAppearanceTransition:YES animated:NO];
        [subject updateSubviewsAnimated:NO];
        return navController;
    });
    
    it(@"looks right with no network connection", ^{
        subject.viewModel.networkQuality = ARNetworkQualityOffline;
        [subject beginAppearanceTransition:YES animated:NO];
        [subject updateSubviewsAnimated:NO];
        expect(navController).to.haveValidSnapshot ();
    });
});

describe(@"during a sync", ^{
    beforeEach(^{
        OCMockObject *mockViewModel = [OCMockObject partialMockForObject:subject.viewModel];
        [[[mockViewModel stub] andReturnValue:@(YES)] isActivelySyncing];
    });
    
    it(@"shows a progress bar", ^{
        [subject beginAppearanceTransition:YES animated:NO];
        [subject updateSubviewsAnimated:NO];
        
        expect(navController).to.haveValidSnapshot();
    });
    
    itHasSnapshotsForDevices(@"updates the bar as sync progress", ^{
        [Expecta setUsesDrawViewHierarchyInRect:YES];

        navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
        [navController pushViewController:subject animated:NO];

        subject.viewModel.timeRemainingInSync = 60;
        subject.viewModel.currentSyncPercentDone = 0.43;
        
        [subject beginAppearanceTransition:YES animated:NO];
        [subject updateSubviewsAnimated:NO];
        
        return navController;
    });
});

SpecEnd

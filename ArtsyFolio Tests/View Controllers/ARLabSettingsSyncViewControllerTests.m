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

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [storyboard instantiateViewControllerWithIdentifier:SyncSettingsViewController];
    
    subject.viewModel = [[ARSyncStatusViewModel alloc] initWithSync:nil context:context qualityIndicator:[[ARStubbedNetworkQualityIndicator alloc] init]];
});

describe(@"viewing sync records", ^{
    beforeEach(^{
        navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
        subject.viewModel.networkQuality = ARNetworkQualityGood;
    });
    
    it(@"looks right with no previous syncs", ^{
        [navController pushViewController:subject animated:NO];
        expect(navController).to.haveValidSnapshot ();
    });
    
    it(@"looks right with existing sync records", ^{
        SyncLog *syncLog = [SyncLog objectInContext:context];
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        syncLog.dateStarted = [formatter dateFromString:@"2015-10-31T02:22:22"];
        
        SyncLog *syncLog1 = [SyncLog objectInContext:context];
        syncLog1.dateStarted = [formatter dateFromString:@"2015-11-17T02:22:22"];
        
        [navController pushViewController:subject animated:NO];
        expect(navController).to.haveValidSnapshot();
    });
});

describe(@"responding to network changes", ^{
    beforeEach(^{
        navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
        [navController pushViewController:subject animated:NO];
    });
    
    it(@"looks right with good network quality", ^{
        subject.viewModel.networkQuality = ARNetworkQualityGood;
        [subject beginAppearanceTransition:YES animated:NO];
        [subject updateSubviewsAnimated:NO];
        expect(navController).to.haveValidSnapshot ();
    });
    
    it(@"looks right with poor network quality", ^{
        subject.viewModel.networkQuality = ARNetworkQualitySlow;
        [subject beginAppearanceTransition:YES animated:NO];
        [subject updateSubviewsAnimated:NO];
        expect(navController).to.haveValidSnapshot ();
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
        navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
        [navController pushViewController:subject animated:NO];
    });
    
    it(@"shows a progress bar", ^{
        OCMockObject *mockViewModel = [OCMockObject partialMockForObject:subject.viewModel];
        [[[mockViewModel stub] andReturnValue:@(YES)] isActivelySyncing];
        subject.viewModel = (id)mockViewModel;
        
        [subject beginAppearanceTransition:YES animated:NO];
        
        [subject updateSubviewsAnimated:NO];
        
        expect(navController).to.haveValidSnapshot();
    });
    
    it(@"updates the bar as sync progress", ^{
        OCMockObject *mockViewModel = [OCMockObject partialMockForObject:subject.viewModel];
        [[[mockViewModel stub] andReturnValue:@(YES)] isActivelySyncing];
        subject.viewModel = (id)mockViewModel;
        
        [subject beginAppearanceTransition:YES animated:NO];
        [subject updateSubviewsAnimated:NO];
        
        subject.viewModel.currentSyncPercentDone = 0.43;
        
        expect(navController).to.haveValidSnapshot();
    });
});

SpecEnd

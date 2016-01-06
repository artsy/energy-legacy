#import "ARLabSettingsSyncViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARSyncStatusViewModel.h"
#import "SyncLog.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "ARStubbedNetworkQualityIndicator.h"


@interface ARLabSettingsSyncViewController ()
@property (nonatomic, strong) ARSyncStatusViewModel *viewModel;
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
    });
    
    it(@"looks right with good network quality", ^{
        [navController pushViewController:subject animated:NO];
        subject.viewModel.networkQuality = ARNetworkQualityGood;
        expect(navController).to.haveValidSnapshot ();
    });
    
    it(@"looks right with poor network quality", ^{
        [navController pushViewController:subject animated:NO];
        subject.viewModel.networkQuality = ARNetworkQualitySlow;
        expect(navController).to.haveValidSnapshot ();
    });
    
    it(@"looks right with no network connection", ^{
        [navController pushViewController:subject animated:NO];
        subject.viewModel.networkQuality = ARNetworkQualityOffline;
        expect(navController).to.haveValidSnapshot ();
    });
});

SpecEnd

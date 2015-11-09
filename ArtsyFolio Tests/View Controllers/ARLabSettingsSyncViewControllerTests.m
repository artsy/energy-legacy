#import "ARLabSettingsNavigationController.h"
#import "ARLabSettingsSyncViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARSyncStatusViewModel.h"
#import "SyncLog.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

SpecBegin(ARLabSettingsSyncViewController);

__block NSManagedObjectContext *context;
__block ARLabSettingsSyncViewController *subject;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
    subject = [sb instantiateViewControllerWithIdentifier:SyncSettingsViewController];
    
    subject.viewModel = [[ARSyncStatusViewModel alloc] initWithSync:nil context:context];
});

describe(@"visuals", ^{
    it(@"looks right with no previous syncs", ^{
        expect(subject).to.haveValidSnapshot();
    });
    
    it(@"looks right with existing sync records", ^{
        SyncLog *syncLog = [SyncLog objectInContext:context];
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        syncLog.dateStarted = [formatter dateFromString:@"2015-10-31T02:22:22"];
        
        SyncLog *syncLog1 = [SyncLog objectInContext:context];
        syncLog1.dateStarted = [formatter dateFromString:@"2015-11-17T02:22:22"];
        
        expect(subject).to.haveValidSnapshot();
    });
});

SpecEnd

#import "ARLabSettingsSplitViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARSyncStatusViewModel.h"
#import "SyncLog.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

id mockSyncViewModel(void);

SpecBegin(ARLabSettingsViewController);

__block ARLabSettingsSplitViewController *controller;
__block id mockManager;
__block NSManagedObjectContext *context;
__block ARSyncStatusViewModel *syncViewModel;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    
    SyncLog *syncLog = [SyncLog objectInContext:context];
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    syncLog.dateStarted = [formatter dateFromString:@"2015-10-31T02:22:22"];
    
    syncViewModel = [[ARSyncStatusViewModel alloc] initWithSync:nil context:context];
});

afterEach(^{
    [mockManager stopMocking];
});

describe(@"visuals", ^{
    it(@"looks right by default", ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
        controller = [storyboard instantiateInitialViewController];
        controller.delegate = mockManager;
        expect(controller).to.haveValidSnapshot();
    });
});

SpecEnd

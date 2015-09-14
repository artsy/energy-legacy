#import "ARSettingsViewController.h"
#import "ARDefaults.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "NSDate+Presentation.h"
#import "ARSyncStatusViewModel.h"

@interface ARSettingsViewController () <UITableViewDelegate>
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) ARSyncStatusViewModel *syncStatusViewModel;
@end

@interface ARSyncStatusViewModel ()
- (ARSyncStatus)syncStatus;
- (NSString *)lastSyncedString;
@end

SpecBegin(ARSettingsViewController);

__block ARSettingsViewController *controller;
__block id mockViewModel;

beforeEach(^{
    ARSyncStatusViewModel *viewModel = [[ARSyncStatusViewModel alloc] init];
    mockViewModel = [OCMockObject partialMockForObject:viewModel];
    [[[mockViewModel stub] andReturn:@"Last synced Nov 24, 2013, 6:59 AM"] lastSyncedString];

    controller = [[ARSettingsViewController alloc] init];
    controller.syncStatusViewModel = mockViewModel;

});

afterEach(^{
    [mockViewModel stopMocking];
});


it(@"looks correct with sync recommendation", ^{
    [[[mockViewModel stub] andReturnValue:@(ARSyncStatusRecommendSync)] syncStatus];

    controller.view.frame = (CGRect){0,0,controller.preferredContentSize};

    expect(controller.view).to.recordSnapshot();
});

it(@"looks correct offline", ^{
    [[[mockViewModel stub] andReturnValue:@(ARSyncStatusOffline)] syncStatus];

    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller.view).to.recordSnapshot();
});

it(@"looks correct when up-to-date", ^{
    [[[mockViewModel stub] andReturnValue:@(ARSyncStatusUpToDate)] syncStatus];

    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller.view).to.recordSnapshot();
});

it(@"looks correct when syncing", ^{
    [[[mockViewModel stub] andReturnValue:@(ARSyncStatusSyncing)] syncStatus];

    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller.view).to.recordSnapshot();
});

it(@"does not support tapping on the sync message", ^{

    controller = [[ARSettingsViewController alloc] init];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [navController beginAppearanceTransition:YES animated:NO];
    [navController endAppearanceTransition];

    expect(navController.topViewController).to.equal(controller);

    NSIndexPath *searchPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [controller tableView:nil didSelectRowAtIndexPath:searchPath];

    expect(navController.topViewController).to.equal(controller);
});

SpecEnd

#import "ARSettingsViewController.h"
#import "Reachability+ConnectionExists.h"
#import "ARDefaults.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "NSDate+Presentation.h"


@interface ARSettingsViewController () <UITableViewDelegate>
@property (nonatomic, strong) NSUserDefaults *defaults;
- (NSString *)lastSyncedString;
@end

SpecBegin(ARSettingsViewController);

__block ARSettingsViewController *controller;
__block id reachabilityMock;

beforeEach(^{
    reachabilityMock = [OCMockObject mockForClass:Reachability.class];

    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    formatter.defaultTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *referenceDate = [formatter dateFromString:@"2013-11-24T06:59:43.431Z"];
    id date = [OCMockObject partialMockForObject:referenceDate];
    [[[date stub] andReturn:@"Nov 24, 2013, 6:59 AM"] formattedString];
    
    controller = [[ARSettingsViewController alloc] init];
    controller.defaults = (id)[ForgeriesUserDefaults defaults: @{
       ARLastSyncDate: referenceDate
   }];
});

afterEach(^{
    [reachabilityMock stopMocking];
});

it(@"returns the right sync notification string", ^{
    expect(controller.lastSyncedString).to.equal(@"Last synced Nov 24, 2013, 6:59 AM");
});

it(@"looks correct with sync recommendation", ^{
    [controller.defaults setBool:YES forKey:ARRecommendSync];
    
    controller.view.frame = (CGRect){0,0,controller.preferredContentSize};

    expect(controller.view).to.haveValidSnapshot();
});

it(@"looks correct offline", ^{
    [[[reachabilityMock stub] andReturnValue:@(NO)] connectionExists];

    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller.view).to.haveValidSnapshot();
});

it(@"looks correct when up-to-date", ^{
    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller.view).to.haveValidSnapshot();
});

it(@"enables button when app returns to online", ^{
    [[[reachabilityMock stub] andReturnValue:@(NO)] connectionExists];
    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    [controller loadViewsProgrammatically];
    [reachabilityMock stopMocking];
    [[[reachabilityMock stub] andReturnValue:@(YES)] connectionExists];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];

    expect(controller).to.haveValidSnapshot();
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

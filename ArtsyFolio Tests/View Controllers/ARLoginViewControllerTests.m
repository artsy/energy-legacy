#import "ARLoginViewController.h"
#import "ARStubbedLoginNetworkModel.h"

/// Without this, the tests are dependant on if Eigen is installed
@interface FakeApplication : NSObject
@end


@implementation FakeApplication
- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {}
- (BOOL)openURL:(NSURL *)url { return NO; }
- (BOOL)canOpenURL:(NSURL *)url { return NO; }
@end


@interface ARLoginViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (weak, nonatomic) IBOutlet UIView *appRecommendationView;
@property (nonatomic, strong) UIApplication *sharedApplication;
@property (nonatomic, strong) ARLoginNetworkModel *networkModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)presentPartnerSelectionToolWithJSON:(NSArray *)JSON;
- (void)presentAdminPartnerSelectionTool;
- (void)loginCompleted:(NSNotification *)notification;
@end

SpecBegin(ARLoginViewController);
__block ARLoginViewController *controller;

dispatch_block_t before = ^{
    controller = [[ARLoginViewController alloc] init];
    controller.userDefaults = (id)[[ForgeriesUserDefaults alloc] init];
    controller.sharedApplication = (id)[[FakeApplication alloc] init];
    controller.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
};


it(@"look right on ipad", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        before();
        expect(controller).to.haveValidSnapshot();
    }];
});

// This cannot be tested in Xcode 6, but it works when being ran on an iOS7 devide
// when migrating to iOS8 only this can be changed

pending(@"hides the ad on landscape orientation", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        before();

        BOOL should = [controller shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        expect(should).to.beTruthy();
        expect(controller.appRecommendationView.hidden).to.beTruthy();
    }];
});

it(@"look right on phone", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
        before();
        expect(controller).to.haveValidSnapshot();
    }];
});

it(@"presents partner selection tool for users with multiple partners", ^{
    before();
    controller.networkModel = [[ARStubbedLoginNetworkModel alloc] initWithPartnerCount:ARLoginPartnerCountMany isAdmin:NO];

    id controllerMock = [OCMockObject partialMockForObject:controller];
    [[controllerMock expect] presentPartnerSelectionToolWithJSON:[OCMArg any]];
    [controller loginCompleted:nil];
    [controllerMock verify];
});

it(@"presents admin tool when user is an admin", ^{
    before();
    controller.networkModel = [[ARStubbedLoginNetworkModel alloc] initWithPartnerCount:ARLoginPartnerCountOne isAdmin:YES];

    id controllerMock = [OCMockObject partialMockForObject:controller];
    [[controllerMock expect] presentAdminPartnerSelectionTool];
    [controller loginCompleted:nil];
    [controllerMock verify];
});

it(@"correctly parses in a partner", ^{
    before();
    controller.networkModel = [[ARStubbedLoginNetworkModel alloc] initWithPartnerCount:ARLoginPartnerCountOne isAdmin:NO];

    [controller loginCompleted:nil];

    expect([[Partner currentPartnerInContext:controller.managedObjectContext] name]).to.equal(@"Test Partner");
});

SpecEnd

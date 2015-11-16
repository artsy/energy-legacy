#import "ARAdminSettingsViewController.h"
#import "ARDefaults.h"
#import "AROptions.h"
#import "ARTheme.h"
#import "Partner+InventoryHelpers.h"


@interface ARAdminSettingsViewController () <UITableViewDelegate>
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

SpecBegin(ARAdminSettingsViewController);

__block ARAdminSettingsViewController *controller;
__block OCMockObject *partnerClassMock;
__block NSManagedObjectContext *context;
__block Partner *partner;
__block ForgeriesUserDefaults *offDefaults, *onDefaults;

beforeEach(^{
    [ARTestContext setContext:ARTestContextDeviceTypePad];

    context = [CoreDataManager stubbedManagedObjectContext];

    partner = [Partner objectInContext:context];
    partnerClassMock = [OCMockObject partialMockForObject:partner];

    offDefaults = [[ForgeriesUserDefaults alloc] init];
    onDefaults = [ForgeriesUserDefaults defaults:@{
        ARHideWorksNotForSale: @(YES),
        AROptionsUseWhiteFolio: @(YES),
        ARHideUnpublishedWorks: @(YES),
        ARShowPrices: @(YES),
        ARShowConfidentialNotes: @(YES),
    }];
});

afterEach(^{
    [partnerClassMock stopMocking];
    [ARTestContext endContext];
});

describe(@"looks correct when", ^{
    
    it(@"is just white folio", ^{
        controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
        controller.defaults = (id)offDefaults;
        controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
        expect(controller).to.haveValidSnapshot();
    });

    it(@"has published works", ^{
        [[[partnerClassMock expect] andReturnValue:@(YES)] hasPublishedWorks];

        controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
        controller.defaults = (id)offDefaults;
        controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
        expect(controller).to.haveValidSnapshot();

        [partnerClassMock verify];
    });

    it(@"has works with prices", ^{
        [[[partnerClassMock expect] andReturnValue:@(YES)] hasWorksWithPrice];

        controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
        controller.defaults = (id)offDefaults;
        controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
        expect(controller).to.haveValidSnapshot();

        [partnerClassMock verify];
    });

    it(@"has works for sale", ^{
        [[[partnerClassMock expect] andReturnValue:@(YES)] hasForSaleWorks];

        controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
        controller.defaults = (id)offDefaults;
        controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
        expect(controller).to.haveValidSnapshot();

        [partnerClassMock verify];
    });
    
    it(@"has confidential notes", ^{
        [[[partnerClassMock expect] andReturnValue:@(YES)] hasConfidentialNotes];
        
        controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
        controller.defaults = (id)offDefaults;
        controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
        expect(controller).to.haveValidSnapshot();
        
        [partnerClassMock verify];
    });

    describe(@"has shows all options", ^{
        beforeEach(^{
            [[[partnerClassMock expect] andReturnValue:@(YES)] hasForSaleWorks];
            [[[partnerClassMock expect] andReturnValue:@(YES)] hasWorksWithPrice];
            [[[partnerClassMock expect] andReturnValue:@(YES)] hasPublishedWorks];
        });

        afterEach(^{
            [partnerClassMock verify];
        });

        it(@"shows all off", ^{
            controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
            controller.defaults = (id)offDefaults;
            controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
            expect(controller).to.haveValidSnapshot();
        });

        it(@"shows all on", ^{
            controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
            controller.defaults = (id)onDefaults;
            controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
            expect(controller).to.haveValidSnapshot();
        });

    });

    it(@"show lab options", ^{
        NSArray *labOptions = @[
            @{ AROptionsName: @"Option 1", AROptionsKey: @"option2" },
            @{ AROptionsName: @"Option 2", AROptionsKey: @"option2" }
        ];

        controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:labOptions];
        controller.defaults = (id)offDefaults;
        controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
        expect(controller).to.haveValidSnapshot();
    });

    it(@"doesnt show the 'admin' section title when no lab options", ^{
        controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
        controller.defaults = (id)offDefaults;
        controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
        expect(controller).to.haveValidSnapshot();
    });

});

it(@"sets the default when tapped", ^{
    controller = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:nil];
    controller.defaults = (id)offDefaults;

    id themeMock = [OCMockObject mockForClass:ARTheme.class];
    [[[themeMock stub] classMethod] setupWithWhiteFolio:YES];

    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [controller tableView:controller.tableView didSelectRowAtIndexPath:path];

    expect(offDefaults.hasSyncronised).to.beTruthy();
    expect(offDefaults.lastRequestedKey).to.equal(AROptionsUseWhiteFolio);
    expect([offDefaults boolForKey:AROptionsUseWhiteFolio]).to.beTruthy();

    // to ensure there's no side effects of testing
    expect([AROptions boolForOption:AROptionsUseWhiteFolio]).to.beFalsy();
});

SpecEnd

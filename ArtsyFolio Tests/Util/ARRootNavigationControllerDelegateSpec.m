#import "ARRootNavigationControllerDelegate.h"
#import "ARNavigationController.h"
#import "ARTheme.h"

SpecBegin(ARRootNavigationControllerDelegate);

__block NSManagedObjectContext *context;
__block UIViewController *controller, *controller2;
__block ARNavigationController *nav;

before(^{
    [ARTestContext setContext:ARTestContextDeviceTypePad];
    context = [CoreDataManager stubbedManagedObjectContext];
    controller = [[UIViewController alloc] init];
    controller2 = [[UIViewController alloc] init];
    nav = [[ARNavigationController alloc] init];
});

after(^{
    [ARTestContext endContext];
});

it(@"sets a back button correctly on ipad white", ^{
    controller.title = @"Custom";
    [nav setViewControllers:@[controller, controller2] animated:NO];
    [ARTheme setupWithWhiteFolio:NO];
    [nav.navigationBar tintColorDidChange];
    
    expect(nav).to.haveValidSnapshot();
});


it(@"sets a back button correctly on ipad black", ^{
    controller.title = @"Custom Name";
    [nav setViewControllers:@[controller, controller2] animated:NO];
    [ARTheme setupWithWhiteFolio:YES];
    [nav.navigationBar tintColorDidChange];

    expect(nav).to.haveValidSnapshot();

    // Don't leak this global state into other tests
    [ARTheme setupWithWhiteFolio:NO];
});

it(@"always animates when tapping back on iPad", ^{
    [nav setViewControllers:@[controller, controller2] animated:NO];

    [nav.delegate navigationController:nav willShowViewController:controller2 animated:NO];

    id navMock = OCMPartialMock(nav);
    [[navMock expect] popViewControllerAnimated:YES];

    UIButton *back = (id)controller2.navigationItem.leftBarButtonItem.customView;
    [back sendActionsForControlEvents:UIControlEventTouchUpInside];

    [navMock verify];
});

SpecEnd

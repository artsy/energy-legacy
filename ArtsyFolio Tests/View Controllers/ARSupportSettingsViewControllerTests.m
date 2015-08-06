#import "ARSupportSettingsViewController.h"

SpecBegin(ARSupportSettingsViewController);

it(@"looks correct", ^{
    ARSupportSettingsViewController *controller = [[ARSupportSettingsViewController alloc] init];
    controller.view.frame = (CGRect){0, 0, controller.preferredContentSize};
    expect(controller).to.haveValidSnapshot();
});

SpecEnd

#import "ARFolioImageMessageViewController.h"

SpecBegin(ARFolioImageMessageViewController);

__block ARFolioImageMessageViewController *controller;

dispatch_block_t before = ^{
    controller = [[ARFolioImageMessageViewController alloc] init];
    controller.messageText = @"Folio has an important message for you";
    controller.buttonText = @"Click Here";
    controller.image = [UIImage imageNamed:@"EditInCMSScreenshot"];
};

it(@"looks right on iPad", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        before();
        expect(controller).to.haveValidSnapshot();
    }];
});

it(@"looks right on iPhone", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
        before();
        expect(controller).to.haveValidSnapshot();
    }];
});

SpecEnd

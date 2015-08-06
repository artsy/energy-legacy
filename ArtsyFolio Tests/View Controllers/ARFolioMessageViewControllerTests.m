#import "ARFolioMessageViewController.h"

SpecBegin(ARFolioMessageViewController);

__block ARFolioMessageViewController *controller;

dispatch_block_t before = ^{
    controller = [[ARFolioMessageViewController alloc] init];
    controller.messageText = @"Folio has an important message for you";
    controller.callToActionText = @"You should do this thing right now or else";
    controller.buttonText = @"Click Here";
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

it(@"shows the skip button if there's a secondary action iPhone", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
        before();
        controller.secondaryAction = ^(){};
        controller.secondaryButtonText = @"Skippable";
        expect(controller).to.haveValidSnapshot();
    }];
});


SpecEnd

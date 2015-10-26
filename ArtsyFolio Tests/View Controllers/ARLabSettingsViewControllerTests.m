#import "ARLabSettingsViewController.h"
#import "ARStoryboardIdentifiers.h"

SpecBegin(ARLabSettingsViewController);

__block ARLabSettingsViewController *controller;

describe(@"visuals", ^{
    it(@"looks right by default", ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
        controller = [storyboard instantiateViewControllerWithIdentifier:SettingsMasterViewController];
        expect(controller).to.haveValidSnapshot();
    });
});

SpecEnd

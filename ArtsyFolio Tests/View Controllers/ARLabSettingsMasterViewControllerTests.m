#import "ARLabSettingsMasterViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARAppDelegate.h"
#import "ARLabSettingsSectionButton.h"


SpecBegin(ARLabSettingsMasterViewController);

__block ARLabSettingsMasterViewController *subject;

beforeAll(^{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
    subject = [storyboard instantiateViewControllerWithIdentifier:SettingsMasterViewController];
});

describe(@"visuals", ^{
    it(@"looks right by default", ^{
        expect(subject).to.haveValidSnapshot();
    });
});

SpecEnd

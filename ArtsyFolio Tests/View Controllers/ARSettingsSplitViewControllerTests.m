#import "ARSettingsSplitViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARDefaults.h"

SpecBegin(ARSettingsSplitViewController);

__block ARSettingsSplitViewController *subject;
__block UIStoryboard *storyboard;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARSettings" bundle:nil];
});

before(^{
    subject = [storyboard instantiateViewControllerWithIdentifier:@"Settings Split View Controller"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ARHasInitializedPresentationMode];
});

describe(@"on ipad", ^{
    it(@"shows primary view only at first", ^{
        expect(subject).to.haveValidSnapshot();
    });
    
    it(@"shows both primary and detail when detail is selected", ^{
        [subject showDetailViewControllerForSettingsSection:ARSettingsSectionBackground];
        expect(subject).to.haveValidSnapshot();
    });
});


SpecEnd

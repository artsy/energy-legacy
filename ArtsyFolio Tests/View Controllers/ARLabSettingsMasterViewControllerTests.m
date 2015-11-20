#import "ARLabSettingsMasterViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARAppDelegate.h"
#import "ARLabSettingsSectionButton.h"
#import "ARLabSettingsMenuViewModel.h"
#import "ARDefaults.h"

@interface ARLabSettingsMasterViewController()
@property ARLabSettingsMenuViewModel *viewModel;
@end

SpecBegin(ARLabSettingsMasterViewController);

__block ARLabSettingsMasterViewController *subject;
__block ARLabSettingsMenuViewModel *viewModel;
__block UIStoryboard *storyboard;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
});

beforeEach(^{
    subject = [storyboard instantiateViewControllerWithIdentifier:SettingsMasterViewController];
});

describe(@"visuals", ^{
    it(@"looks right by default", ^{
        expect(subject).to.haveValidSnapshot();
    });
    
    it(@"looks right when presentation mode is on", ^{
        ForgeriesUserDefaults *defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @YES }];
        subject.viewModel = [[ARLabSettingsMenuViewModel alloc] initWithDefaults:(id)defaults appDelegate:[[ARAppDelegate alloc] init]];
        
        expect(subject).to.haveValidSnapshot();
    });
});

SpecEnd

#import "ARLabSettingsMasterViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARAppDelegate.h"
#import "ARLabSettingsSectionButton.h"
#import "ARLabSettingsMenuViewModel.h"
#import "ARDefaults.h"


@interface ARLabSettingsMasterViewController ()
@property ARLabSettingsMenuViewModel *viewModel;
- (IBAction)presentationModeButtonPressed:(id)sender;
@end

SpecBegin(ARLabSettingsMasterViewController);

__block ARLabSettingsMasterViewController *subject;
__block ARLabSettingsMenuViewModel *viewModel;
__block UIStoryboard *storyboard;
__block ForgeriesUserDefaults *defaults;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
});

beforeEach(^{
    subject = [storyboard instantiateViewControllerWithIdentifier:SettingsMasterViewController];
});

describe(@"visuals", ^{
    itHasSnapshotsForDevices(@"looks right by default", ^{
        UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:SettingsPrimaryNavigationController];
        [nav pushViewController:subject animated:NO];
        return nav;
    });
    
    it(@"looks right when presentation mode is on", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @YES }];
        subject.viewModel = [[ARLabSettingsMenuViewModel alloc] initWithDefaults:(id)defaults appDelegate:[[ARAppDelegate alloc] init]];
        
        expect(subject).to.haveValidSnapshot();
    });
});

describe(@"toggling presentation mode", ^{
    
    it(@"posts a grid view filtering notification when turning pres mode on", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @NO }];
        subject.viewModel = [[ARLabSettingsMenuViewModel alloc] initWithDefaults:(id)defaults appDelegate:[[ARAppDelegate alloc] init]];
        
        expect(^{[subject presentationModeButtonPressed:nil];}).to.notify(ARUserDidChangeGridFilteringSettingsNotification);
    });

    it(@"posts a grid view filtering notification when turning pres mode off", ^{
        defaults = [ForgeriesUserDefaults defaults:@{ ARPresentationModeOn: @YES }];
        subject.viewModel = [[ARLabSettingsMenuViewModel alloc] initWithDefaults:(id)defaults appDelegate:[[ARAppDelegate alloc] init]];
        
        expect(^{[subject presentationModeButtonPressed:nil];}).to.notify(ARUserDidChangeGridFilteringSettingsNotification);
    });
});

SpecEnd

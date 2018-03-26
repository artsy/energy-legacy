#import "AREmailSettingsViewModel.h"
#import "AREmailSettingsViewController.h"
#import "AREmailSubjectLineSettingsViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARDefaults.h"
#import <Artsy+UIColors/UIColor+ArtsyColors.h>
#import <Forgeries/ForgeriesUserDefaults+Mocks.h>


@interface AREmailSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *ccEmailTextView;
@end


@interface AREmailSubjectLineSettingsViewController ()
@property (nonatomic, assign) AREmailSubjectType subjectType;
@end

SpecBegin(AREmailSettingsViewController);

__block UIStoryboard *storyboard;
__block AREmailSettingsViewController *subject;
__block UINavigationController *navController;
__block ForgeriesUserDefaults *mockDefaults;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARSettings" bundle:nil];
});

beforeEach(^{
    subject = [storyboard instantiateViewControllerWithIdentifier:EmailSettingsViewController];
});

describe(@"visuals", ^{

    beforeEach(^{
        navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
    });

    it(@"looks right by default", ^{
        mockDefaults = [ForgeriesUserDefaults defaults:@{ AREmailCCEmail : @"email@gallery.com",
                                                          AREmailGreeting : @"Here is a nice email about sculpture.",
                                                          AREmailSignature : @"Signature"
        }];

        subject.viewModel = [[AREmailSettingsViewModel alloc] initWithDefaults:(id)mockDefaults];

        [navController pushViewController:subject animated:NO];
        expect(navController).to.haveValidSnapshot();
    });

    it(@"looks right during text editing", ^{
        [subject beginAppearanceTransition:YES animated:NO];

        [subject textViewDidBeginEditing:subject.ccEmailTextView];

        [navController pushViewController:subject animated:NO];
        expect(navController).to.haveValidSnapshot();
    });
});

describe(@"subject lines tableView", ^{
    it(@"has a cell for each subject line possibility", ^{
        [subject beginAppearanceTransition:YES animated:NO];
        expect([subject.tableView numberOfRowsInSection:0]).to.equal(3);
    });
});

describe(@"saving defaults", ^{
    it(@"saves new email defaults after editing", ^{
        mockDefaults = [ForgeriesUserDefaults defaults:@{ AREmailCCEmail : @"email@gallery.com" }];
        subject.viewModel = [[AREmailSettingsViewModel alloc] initWithDefaults:(id)mockDefaults];
        [subject beginAppearanceTransition:YES animated:NO];

        subject.ccEmailTextView.text = @"newEmail@gallery.com";
        [subject textViewDidEndEditing:subject.ccEmailTextView];

        expect([mockDefaults stringForKey:AREmailCCEmail]).to.equal(@"newEmail@gallery.com");
    });
});

SpecEnd

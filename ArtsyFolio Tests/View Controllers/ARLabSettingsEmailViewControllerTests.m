#import "ARLabSettingsEmailViewModel.h"
#import "ARLabSettingsEmailViewController.h"
#import "ARLabSettingsEmailSubjectLinesViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARDefaults.h"
#import <Artsy+UIColors/UIColor+ArtsyColors.h>


@interface ARLabSettingsEmailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *ccEmailTextView;
@end


@interface ARLabSettingsEmailSubjectLinesViewController ()
@property (nonatomic, assign) AREmailSubjectType subjectType;
@end

SpecBegin(ARLabSettingsEmailViewController);

__block UIStoryboard *storyboard;
__block ARLabSettingsEmailViewController *subject;
__block ForgeriesUserDefaults *mockDefaults;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
});

beforeEach(^{
    subject = [storyboard instantiateViewControllerWithIdentifier:EmailSettingsViewController];

});

describe(@"visuals", ^{
    it(@"looks right by default", ^{
        mockDefaults = [ForgeriesUserDefaults defaults:@{ AREmailCCEmail : @"email@gallery.com",
                                                          AREmailGreeting : @"Here is a nice email about sculpture.",
                                                          AREmailSignature : @"Signature"
                                                    }];
        
        subject.viewModel = [[ARLabSettingsEmailViewModel alloc] initWithDefaults:(id)mockDefaults];
        
        expect(subject).to.haveValidSnapshot();
    });
    
    it(@"looks right during text editing", ^{
        [subject beginAppearanceTransition:YES animated:NO];
        
        [subject textViewDidBeginEditing:subject.ccEmailTextView];
        expect(subject).to.haveValidSnapshot();
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
        subject.viewModel = [[ARLabSettingsEmailViewModel alloc] initWithDefaults:(id)mockDefaults];
        [subject beginAppearanceTransition:YES animated:NO];
        
        subject.ccEmailTextView.text = @"newEmail@gallery.com";
        [subject textViewDidEndEditing:subject.ccEmailTextView];
        
        expect([mockDefaults stringForKey:AREmailCCEmail]).to.equal(@"newEmail@gallery.com");
    });
});

SpecEnd

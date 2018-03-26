#import "AREmailSubjectLineSettingsViewController.h"
#import "AREmailSettingsViewModel.h"
#import "ARStoryboardIdentifiers.h"
#import "ARDefaults.h"
#import <Forgeries/ForgeriesUserDefaults+Mocks.h>

UITextView *textViewInSubject(AREmailSubjectLineSettingsViewController *subject);

SpecBegin(AREmailSubjectLineSettingsViewController);

__block UIStoryboard *storyboard;
__block AREmailSubjectLineSettingsViewController *subject;
__block AREmailSettingsViewModel *viewModel;
__block ForgeriesUserDefaults *mockDefaults;
__block UITextView *textView;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARSettings" bundle:nil];
});

beforeEach(^{
    subject = [storyboard instantiateViewControllerWithIdentifier:EmailSubjectSettingsViewController];
    mockDefaults = [ForgeriesUserDefaults defaults:@{
        AREmailSubject : @"More information about %@ by %@",
        ARMultipleEmailSubject : @"More information about the artworks we discussed",
        ARMultipleSameArtistEmailSubject : @"More information about %@'s artworks"
    }];
    viewModel = [[AREmailSettingsViewModel alloc] initWithDefaults:(id)mockDefaults];
});

describe(@"visuals", ^{
    it(@"looks right for one artwork subjects", ^{
        [subject setupWithSubjectType:AREmailSubjectTypeOneArtwork viewModel:viewModel];
        expect(subject).to.haveValidSnapshot();
    });
    it(@"looks right for multiple artist subjects", ^{
        [subject setupWithSubjectType:AREmailSubjectTypeMultipleArtworksMultipleArtists viewModel:viewModel];
        expect(subject).to.haveValidSnapshot();
    });
    it(@"looks right for one artist multiple artworks subjects", ^{
        [subject setupWithSubjectType:AREmailSubjectTypeMultipleArtworksSameArtist viewModel:viewModel];
        expect(subject).to.haveValidSnapshot();
    });
    it(@"looks right when editing text", ^{
        [subject setupWithSubjectType:AREmailSubjectTypeMultipleArtworksSameArtist viewModel:viewModel];

        textView = textViewInSubject(subject);
        [subject textViewDidBeginEditing:textView];

        expect(subject).to.haveValidSnapshot();
    });
});

describe(@"saving email defaults", ^{
    it(@"saves new one artwork subjects", ^{
        [subject setupWithSubjectType:AREmailSubjectTypeOneArtwork viewModel:viewModel];

        textView = textViewInSubject(subject);
        textView.text = @"More info about one artwork by one person";
        [subject textViewDidEndEditing:textView];

        expect([mockDefaults objectForKey:AREmailSubject]).to.equal(textView.text);
    });

    it(@"saves new multiple artist subjects", ^{
        [subject setupWithSubjectType:AREmailSubjectTypeMultipleArtworksMultipleArtists viewModel:viewModel];

        textView = textViewInSubject(subject);
        textView.text = @"More info about artworks by several people";
        [subject textViewDidEndEditing:textView];

        expect([mockDefaults objectForKey:ARMultipleEmailSubject]).to.equal(textView.text);
    });

    it(@"saves new multiple artworks by same artist subjects", ^{
        [subject setupWithSubjectType:AREmailSubjectTypeMultipleArtworksSameArtist viewModel:viewModel];

        textView = textViewInSubject(subject);
        textView.text = @"More info about several artworks by one person";
        [subject textViewDidEndEditing:textView];

        expect([mockDefaults objectForKey:ARMultipleSameArtistEmailSubject]).to.equal(textView.text);
    });
});

SpecEnd


    UITextView *
    textViewInSubject(AREmailSubjectLineSettingsViewController *subject)
{
    [subject beginAppearanceTransition:YES animated:NO];

    return [subject.view.subviews find:^BOOL(id object) {
        return [object isKindOfClass:UITextView.class];
    }];
}

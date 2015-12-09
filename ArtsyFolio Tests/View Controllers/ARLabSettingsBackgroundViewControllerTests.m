#import "ARLabSettingsBackgroundViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "AROptions.h"

SpecBegin(ARLabSettingsBackgroundViewController);

__block UIStoryboard *storyboard;
__block ARLabSettingsBackgroundViewController *subject;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
});

beforeEach(^{
    subject = [storyboard instantiateViewControllerWithIdentifier:BackgroundSettingsViewController];
    subject.defaults = (id)[ForgeriesUserDefaults defaults:@{ AROptionsUseWhiteFolio : @NO}];
});

describe(@"visuals", ^{

    it(@"looks right when white Folio is off", ^{
        expect(subject).to.haveValidSnapshot();
    });
    
    it(@"looks right when white Folio is on", ^{
        [subject.defaults setBool:YES forKey:AROptionsUseWhiteFolio];
        expect(subject).to.haveValidSnapshot();
    });
});

describe(@"toggling", ^{
    it(@"sets the white folio default when tapped", ^{
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [subject tableView:subject.tableView didSelectRowAtIndexPath:path];
        
        expect([subject.defaults boolForKey:AROptionsUseWhiteFolio]).to.beTruthy();
        
        [subject tableView:subject.tableView didSelectRowAtIndexPath:path];
        
        expect([subject.defaults boolForKey:AROptionsUseWhiteFolio]).to.beFalsy();
    });
});

SpecEnd

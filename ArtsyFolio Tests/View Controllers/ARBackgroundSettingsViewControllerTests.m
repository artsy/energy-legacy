#import "ARBackgroundSettingsViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "AROptions.h"

SpecBegin(ARBackgroundSettingsViewController);

__block UIStoryboard *storyboard;
__block ARBackgroundSettingsViewController *subject;
__block UINavigationController *navController;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARSettings" bundle:nil];
});

beforeEach(^{
    subject = [storyboard instantiateViewControllerWithIdentifier:BackgroundSettingsViewController];
    subject.defaults = (id)[ForgeriesUserDefaults defaults:@{ AROptionsUseWhiteFolio : @NO}];
});

describe(@"visuals", ^{
    beforeEach(^{
        navController = [storyboard instantiateViewControllerWithIdentifier:SettingsNavigationController];
    });

    it(@"looks right when white Folio is off", ^{
        [navController pushViewController:subject animated:NO];
        expect(navController).to.haveValidSnapshot();
    });
    
    it(@"looks right when white Folio is on", ^{
        [subject.defaults setBool:YES forKey:AROptionsUseWhiteFolio];
        [navController pushViewController:subject animated:NO];
        expect(navController).to.haveValidSnapshot();
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

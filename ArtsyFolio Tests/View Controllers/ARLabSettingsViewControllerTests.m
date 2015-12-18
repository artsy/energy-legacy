#import "ARLabSettingsSplitViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARLabSettingsMasterViewController.h"

SpecBegin(ARLabSettingsViewController);

__block ARLabSettingsSplitViewController *subject;
__block NSManagedObjectContext *context;
__block UIStoryboard *storyboard;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
});

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [storyboard instantiateViewControllerWithIdentifier:@"Settings Split View Controller"];
});

describe(@"on ipad", ^{
    it(@"shows primary view only at first", ^{
        expect(subject).to.haveValidSnapshot();
    });
    
    it(@"shows both primary and detail when detail is selected", ^{
        [subject showDetailViewControllerForSettingsSection:ARLabSettingsSectionBackground];
        expect(subject).to.haveValidSnapshot();
    });
});


SpecEnd

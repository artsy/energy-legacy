#import "ARLabSettingsSplitViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARLabSettingsNavigationController.h"

SpecBegin(ARLabSettingsViewController);

__block ARLabSettingsSplitViewController *subject;
__block ARLabSettingsNavigationController *nav;
__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
});

describe(@"visuals", ^{
    it(@"looks right by default", ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
        subject = [storyboard instantiateInitialViewController];
        
        nav = [subject.viewControllers find:^BOOL(id object) {
            return [object isKindOfClass:ARLabSettingsNavigationController.class];
        }];
        
        nav.managedObjectContext = context;
        
        expect(subject).to.haveValidSnapshot();
    });
});


SpecEnd

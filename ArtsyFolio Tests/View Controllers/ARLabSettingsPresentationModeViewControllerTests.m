#import "ARLabSettingsNavigationController.h"
#import "ARLabSettingsPresentationModeViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARModelFactory.h"


SpecBegin(ARLabSettingsPresentationModeViewController);

__block NSManagedObjectContext *context;
__block ARLabSettingsPresentationModeViewController *subject;
__block UIStoryboard *storyboard;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
});

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    
    subject = [storyboard instantiateViewControllerWithIdentifier:PresentationModeViewController];
    subject.context = context;

});


describe(@"when showing and hiding toggles", ^{
    it(@"shows confidential notes toggle when artwork has confidential notes", ^{
    });
    
    it(@"shows Hide Prices toggle when artworks exist with prices", ^{
        
    });
    
    it(@"shows Hide Prices For Sold Works and Hide Not For Sale works when there are sold works ", ^{
        
    });
    
    it(@"shows Hide Unpublished Works when there are mixed published works", ^{
    });
    
    it(@"doesn't show Hide Unpublished Works when there are only unpublished works", ^{
    });
    
    it(@"doesn't show Hide Unpublished Works when there are only published works", ^{
    });
});

describe(@"setting defaults", ^{
    it(@"shows all toggles off when defaults are false", ^{
        
    });

    it(@"shows all toggles on when defaults are true", ^{
        
    });

});

describe(@"no presentation mode settings", ^{
    it(@"handles this state correctly", ^{
        
    });
});

SpecEnd

#import "ARLabSettingsNavigationController.h"
#import "ARLabSettingsPresentationModeViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARModelFactory.h"


SpecBegin(ARLabSettingsPresentationModeViewController);

__block NSManagedObjectContext *context;
__block ARLabSettingsPresentationModeViewController *subject;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    Partner *partner = [Partner createInContext:context];
    Artwork *artwork = [Artwork stubbedArtworkWithImages:NO inContext:context];
    artwork.availability = @"for sale";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
    subject = [sb instantiateViewControllerWithIdentifier:PresentationModeViewController];
    subject.context = context;

});

describe(@"visuals", ^{
    it(@"looks right by default", ^{
        expect(subject).to.haveValidSnapshot();
    });
});

SpecEnd

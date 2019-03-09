#import "ARSettingsMenuViewModel.h"
#import "ARDefaults.h"
#import <Forgeries/ForgeriesUserDefaults+Mocks.h>


@interface ARSettingsMenuViewModel (Testing)
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) ARAppDelegate *appDelegate;
@end


SpecBegin(ARSettingsMenuViewModel);

__block ARSettingsMenuViewModel *subject;
__block ForgeriesUserDefaults *defaults;

before(^{
    defaults = [[ForgeriesUserDefaults alloc] init];
    subject = [[ARSettingsMenuViewModel alloc] initWithDefaults:(id)defaults context:[CoreDataManager stubbedManagedObjectContext] appDelegate:[[ARAppDelegate alloc] init]];
    [Partner createInContext:subject.context];
});

describe(@"initializing presentation mode", ^{
    it(@"only initializes defaults once", ^{
        [subject initializePresentationMode];
        expect([defaults boolForKey:ARHasInitializedPresentationMode]).to.beTruthy();
        expect([defaults boolForKey:ARHideArtworkEditButton]).to.beTruthy();

        [defaults setBool:NO forKey:ARHideArtworkEditButton];

        [subject initializePresentationMode];
        expect([defaults boolForKey:ARHideArtworkEditButton]).to.beFalsy();
    });

    it(@"doesnt initialize irrelevant settings", ^{
        /// Creates an artwork with a price
        [ARModelFactory fullArtworkInContext:subject.context];

        [subject initializePresentationMode];

        /// Should ignore defaults that don't pertain to the inventory
        expect([defaults boolForKey:ARHideUnpublishedWorks]).to.beFalsy();
        expect([defaults boolForKey:ARHideWorksNotForSale]).to.beFalsy();

        /// Should not ignore defaults that do
        expect([defaults boolForKey:ARHideAllPrices]).to.beTruthy();
    });
});

describe(@"enabling presentation mode", ^{
    it(@"returns NO if no presentation settings are on", ^{
        expect(subject.shouldEnablePresentationMode).to.beFalsy();
    });

    it(@"returns YES if any presentation settings are on", ^{
        [defaults setBool:YES forKey:ARHideConfidentialNotes];
        expect(subject.shouldEnablePresentationMode).to.beTruthy();
    });
});

describe(@"toggling presentation mode", ^{
    it(@"successfully toggles", ^{
        [defaults setBool:YES forKey:ARPresentationModeOn];
        [subject togglePresentationMode];
        expect([defaults boolForKey:ARPresentationModeOn]).to.beFalsy();
        [subject togglePresentationMode];
        expect([defaults boolForKey:ARPresentationModeOn]).to.beTruthy();
    });
});

describe(@"logging out", ^{
    it(@"tells the app delegate to logout", ^{
        OCMockObject *mockDelegate = [OCMockObject partialMockForObject:subject.appDelegate];

        [[mockDelegate expect] startLogout];
        [subject logout];
        [mockDelegate verify];
    });
});


SpecEnd

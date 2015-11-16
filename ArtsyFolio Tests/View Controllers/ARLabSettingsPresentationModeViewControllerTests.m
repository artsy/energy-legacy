#import "ARLabSettingsNavigationController.h"
#import "ARLabSettingsPresentationModeViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "AROptions.h"
#import "ARDefaults.h"


Artwork *genericArtworkInContext(NSManagedObjectContext *context);
NSInteger numberOfRowsIn(ARLabSettingsPresentationModeViewController *subject);
ForgeriesUserDefaults *offDefaults(void);
ForgeriesUserDefaults *onDefaults(void);

SpecBegin(ARLabSettingsPresentationModeViewController);

__block NSManagedObjectContext *context;
__block ARLabSettingsPresentationModeViewController *subject;
__block UIStoryboard *storyboard;

beforeAll(^{
    storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
});

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    [Partner objectInContext:context];
    
    subject = [storyboard instantiateViewControllerWithIdentifier:PresentationModeViewController];
    subject.context = context;

});

describe(@"when showing and hiding toggles", ^{
    
    /// The 'Hide Confidential Notes' & 'Hide Artwork Edit Button' are always visible
    it(@"shows all prices toggle when artworks exist with prices", ^{
        Artwork *priceArtwork = genericArtworkInContext(context);
        priceArtwork.displayPrice = @"200";
        
        expect(numberOfRowsIn(subject)).to.equal(3);
    });

    it(@"does not show Hide Prices For Sold Works toggle when there are no sold works with prices", ^{
        Artwork *soldArtwork = genericArtworkInContext(context);
        soldArtwork.availability = @"sold";
        soldArtwork.isAvailableForSale = @(NO);

        expect(numberOfRowsIn(subject)).to.equal(2);
    });
    
    it(@"shows Hide Prices For Sold Works and Hide Not For Sale Works toggles when there are sold works with prices", ^{
        Artwork *soldArtwork = genericArtworkInContext(context);
        soldArtwork.availability = @"sold";
        soldArtwork.backendPrice = @"10";
        soldArtwork.isAvailableForSale = @(NO);
        
        expect(numberOfRowsIn(subject)).to.equal(4);
    });
    
    it(@"shows Hide Unpublished Works when there are both published and unpublished works", ^{
        Artwork *publishedArtwork = genericArtworkInContext(context);
        
        Artwork *unpublishedArtwork = genericArtworkInContext(context);
        unpublishedArtwork.isPublished = @(NO);
        
        expect(numberOfRowsIn(subject)).to.equal(3);
    });
    
    it(@"doesn't show Hide Unpublished Works when there are only unpublished works", ^{
        Artwork *unpublishedArtwork = genericArtworkInContext(context);
        unpublishedArtwork.isPublished = @(NO);
        
        expect(numberOfRowsIn(subject)).to.equal(2);
    });
    
    it(@"doesn't show Hide Unpublished Works when there are only published works", ^{
        Artwork *publishedArtwork = genericArtworkInContext(context);
        
        expect(numberOfRowsIn(subject)).to.equal(2);
    });

});

describe(@"setting defaults", ^{
    it(@"shows all toggles off when defaults are false", ^{
        Artwork *publishedArtwork = genericArtworkInContext(context);
        publishedArtwork.backendPrice = @"32";
        publishedArtwork.availability = @"sold";
        
        Artwork *unpublishedArtwork = genericArtworkInContext(context);
        unpublishedArtwork.isPublished = @(NO);
        unpublishedArtwork.isAvailableForSale = @(NO);
        unpublishedArtwork.confidentialNotes = @"fjdkalfjdks";

        subject.defaults = (id)offDefaults();
        
        expect(subject).to.haveValidSnapshot();
    });

    it(@"shows all toggles on when defaults are true", ^{
        Artwork *publishedArtwork = genericArtworkInContext(context);
        publishedArtwork.backendPrice = @"32";
        publishedArtwork.availability = @"sold";
        
        Artwork *unpublishedArtwork = genericArtworkInContext(context);
        unpublishedArtwork.isPublished = @(NO);
        unpublishedArtwork.isAvailableForSale = @(NO);
        unpublishedArtwork.confidentialNotes = @"fjdkalfjdks";
        
        subject.defaults = (id)onDefaults();
        
        expect(subject).to.haveValidSnapshot();
    });

});

describe(@"setting defaults", ^{
    it(@"sets the right default when tapped", ^{
        Artwork *artwork = genericArtworkInContext(context);
        artwork.displayPrice = @"2";
        
        subject.defaults = (id)offDefaults();
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [subject tableView:subject.tableView didSelectRowAtIndexPath:path];
        
        ForgeriesUserDefaults *defaults = (id)subject.defaults;
        expect(defaults.hasSyncronised).to.beTruthy();
        expect(defaults.lastRequestedKey).to.equal(ARHideAllPrices);
        expect([subject.defaults boolForKey:ARHideAllPrices]).to.beTruthy();
    });
});

SpecEnd


    Artwork *
    genericArtworkInContext(NSManagedObjectContext *context)
{
    Artwork *artwork = [Artwork createInContext:context];
    artwork.confidentialNotes = @"";
    artwork.displayPrice = @"";
    artwork.backendPrice = @"";
    artwork.isPublished = @(YES);
    artwork.isAvailableForSale = @(YES);
    return artwork;
}

ForgeriesUserDefaults *offDefaults()
{
    return [[ForgeriesUserDefaults alloc] init];
}

ForgeriesUserDefaults *onDefaults()
{
    return [ForgeriesUserDefaults defaults:@{
        ARHideUnpublishedWorks : @(YES),
        ARHideAllPrices : @(YES),
        ARShowConfidentialNotes : @(YES),
        ARHideConfidentialNotes : @(YES),
        ARHideWorksNotForSale : @(YES),
        ARHidePricesForSoldWorks : @(YES),
        ARHideArtworkEditButton : @(YES),
    }];
}

NSInteger numberOfRowsIn(ARLabSettingsPresentationModeViewController *subject)
{
    return [subject.tableView numberOfRowsInSection:0];
}

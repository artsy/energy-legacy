#import "Partner+InventoryHelpers.h"

SpecBegin(Partner);

__block NSManagedObjectContext *context;
__block Partner *partner;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    partner = [Partner objectInContext:context];
});

it(@"current partner gets first partner in context", ^{
    expect([Partner currentPartnerInContext:context]).to.equal(partner);
});

describe(@"has uploaded works on cms", ^{

    it(@"returns false the partner's artwork count is 0", ^{
        partner.artworksCount = @(0);
        expect(partner.hasUploadedWorks).to.beFalsy();
    });

    it(@"returns true the partner's artwork count is > 0", ^{
        partner.artworksCount = @(1);
        expect(partner.hasUploadedWorks).to.beTruthy();
    });

    it(@"also takes into account the amount of artworks in the MOC", ^{
        Artwork *artwork = [Artwork objectInContext:context];
        partner.artworksCount = @(0);

        expect(partner.hasUploadedWorks).to.beTruthy();
    });
});

describe(@"partner type", ^{
    it(@"is collector for a collector type", ^{
        partner = [Partner modelFromJSON:@{ @"type" : @"Private Collector" } inContext:context];
        expect(partner.type).to.equal(ARPartnerTypeCollector);
    });

    it(@"is a gallery for everything else", ^{
        partner = [Partner modelFromJSON:@{ @"type" : @"Anything" } inContext:context];
        expect(partner.type).to.equal(ARPartnerTypeGallery);

        partner = [Partner modelFromJSON:@{ } inContext:context];
        expect(partner.type).to.equal(ARPartnerTypeGallery);
    });
});

describe(@"available artwork type checks", ^{

    describe(@"published works", ^{
        it(@"returns true when the core data db has published works", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.isPublished = @YES;

            expect(partner.hasPublishedWorks).to.beTruthy();
        });

        it(@"returns false when the core data db has no published works", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.isPublished = @NO;

            expect(partner.hasPublishedWorks).to.beFalsy();
        });
    });

    describe(@"for sale works", ^{
        it(@"returns true when the core data db has works for sale", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.isAvailableForSale = @YES;

            expect(partner.hasForSaleWorks).to.beTruthy();
        });

        it(@"returns false when the core data db has no works for sale", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.isAvailableForSale = @NO;

            expect(partner.hasPublishedWorks).to.beFalsy();
        });
    });
    
    describe(@"sold works", ^{
        it(@"returns true when the core data db has sold works", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.availability = @"sold";
            
            expect(partner.hasSoldWorks).to.beTruthy();
        });
        
        it(@"returns false when the core data db has no sold works", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.availability = @"on hold";
            
            expect(partner.hasSoldWorks).to.beFalsy();
        });
        
        it(@"returns true when the core data db has sold works with prices", ^{
            Artwork *artwork0 = [Artwork objectInContext:context];
            artwork0.availability = @"sold";
            artwork0.displayPrice = @"200";
            
            expect(partner.hasSoldWorksWithPrices).to.beTruthy();
        });
        
        it(@"returns false when the core data db has sold works without prices only", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.availability = @"sold";
            artwork.displayPrice = @"";
            artwork.backendPrice = @"";
            
            expect(partner.hasSoldWorksWithPrices).to.beFalsy();
        });
        
        it(@"returns false when the core data db has sold works without prices only and for sale works with prices", ^{
            Artwork *artwork0 = [Artwork objectInContext:context];
            artwork0.availability = @"sold";
            artwork0.displayPrice = @"";
            artwork0.backendPrice = @"";
            
            Artwork *artwork1 = [Artwork objectInContext:context];
            artwork1.availability = @"for sale";
            artwork1.displayPrice = @"300";
            
            expect(partner.hasSoldWorksWithPrices).to.beFalsy();
        });
    });

    describe(@"for works with price", ^{
        it(@"returns true when the core data db has works with a display price", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.displayPrice = @"over 9000";

            expect(partner.hasWorksWithPrice).to.beTruthy();
        });

        it(@"returns true when the core data db has works with a backend price", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.backendPrice = @"over 9000";

            expect(partner.hasWorksWithPrice).to.beTruthy();
        });

        it(@"returns false when the core data db has no works with prices", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.displayPrice = @"";
            artwork.backendPrice = @"";

            expect(partner.hasPublishedWorks).to.beFalsy();
        });
    });
    
    describe(@"for works with confidential notes", ^{
        it(@"returns true when partner has works with conf. notes", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.confidentialNotes = @"super secret";
            
            expect(partner.hasConfidentialNotes).to.beTruthy();
        });
        
        it(@"returns false when partner has no works with conf. notes", ^{
            Artwork *artwork = [Artwork objectInContext:context];
            artwork.confidentialNotes = @"";
            
            expect(partner.hasConfidentialNotes).to.beFalsy();
        });
    });

});
SpecEnd

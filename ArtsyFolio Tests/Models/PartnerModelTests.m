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

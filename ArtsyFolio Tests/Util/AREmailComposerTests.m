#import "Artwork.h"
#import "Artist.h"
#import "EditionSet.h"
#import "AREmailComposer.h"
#import "ARDefaults.h"
#import "AREmailSettings.h"


@interface AREmailComposer ()
@property (nonatomic, strong) UIViewController<MFMailComposeViewControllerDelegate> *parentViewController;
@property (nonatomic, strong) MFMailComposeViewController *mailController;
@property (nonatomic, copy) NSUserDefaults *defaults;

@property (readwrite, nonatomic, strong) AREmailSettings *options;
@property (readwrite, nonatomic, copy) NSArray *documents;
@property (readwrite, nonatomic, copy) NSString *subject;
@property (readwrite, nonatomic, copy) NSArray *artworks;
@end

SpecBegin(AREmailComposer);

__block AREmailComposer *composer;
__block ForgeriesUserDefaults *defaults;
__block NSManagedObjectContext *context;
__block AREmailSettings *settings;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    composer = [[AREmailComposer alloc] init];
    defaults = [[ForgeriesUserDefaults alloc] init];
    
    composer.defaults = (id)defaults;
    composer.options = settings;
});

describe(@"standard email settings", ^{
    it(@"generates one cc email address when only one is entered", ^{
       defaults[AREmailCCEmail] = @"email@aol.com";
        expect([composer generateCCEmails:defaults[AREmailCCEmail]]).to.equalArray(@[@"email@aol.com"]);
    });
    
    it(@"generates an array of cc email addresses when there are more than one", ^{
        defaults[AREmailCCEmail] = @"email1@aol.com,email2@aol.com";
        expect([composer generateCCEmails:defaults[AREmailCCEmail]]).to.equalArray(@[@"email1@aol.com", @"email2@aol.com"]);
    });
});

describe(@"with 1 artwork", ^{
    __block Artwork *artwork;

    beforeEach(^{
        Artist *artist = [Artist objectInContext:context];
        artist.displayName = @"Artist Name";

        artwork = [Artwork objectInContext:context];
        artwork.title = @"Artwork Name";
        artwork.artist = artist;
        composer.artworks = @[ artwork ];
    });

    it(@"uses the default", ^{
        defaults[AREmailSubject] = @"subject";
        [composer subject];
        expect(defaults.lastRequestedKey).to.equal(AREmailSubject);
    });

    it(@"shows default if no %@", ^{
        NSString *subject = @"Marmite";
        defaults[AREmailSubject] = subject;
        expect([composer subject]).to.equal(subject);
    });

    it(@"replaces one %@ with artwork title", ^{
        NSString *subject = @"Check out %@";
        defaults[AREmailSubject] = subject;
        expect([composer subject]).to.contain(artwork.title);
    });

    it(@"replaces two %@s with artwork & artist", ^{
        NSString *subject = @"Check out %@ by %@";
        defaults[AREmailSubject] = subject;
        expect([composer subject]).to.contain(artwork.title);
        expect([composer subject]).to.contain(artwork.artist.presentableName);
    });
});


describe(@"with artworks > 1", ^{
    __block Artwork *artwork, *artwork2, *untitledArtwork;

    describe(@"with the same artist", ^{
        beforeEach(^{
            Artist *artist = [Artist objectInContext:context];
            artist.displayName = @"Artist Name";

            artwork = [Artwork objectInContext:context];
            artwork.title = @"Artwork Name";
            artwork.artist = artist;

            artwork2 = [Artwork objectInContext:context];
            artwork2.title = @"Artwork2 Name";
            artwork2.artist = artist;
            
            untitledArtwork = [Artwork objectInContext:context];
            untitledArtwork.artist = artist;
            
            composer.artworks = @[ artwork, artwork2 ];
        });

        it(@"uses the default", ^{
            defaults[ARMultipleSameArtistEmailSubject] = @"subject";
            [composer subject];
            expect(defaults.lastRequestedKey).to.equal(ARMultipleSameArtistEmailSubject);
        });

        it(@"shows default if no %@", ^{
            NSString *subject = @"Marmite";
            defaults[ARMultipleSameArtistEmailSubject] = subject;
            expect([composer subject]).to.equal(subject);
        });

        it(@"replaces one %@ with artist name", ^{
            NSString *subject = @"Check out %@";
            defaults[ARMultipleSameArtistEmailSubject] = subject;
            expect([composer subject]).to.contain(artwork.artist.presentableName);
        });

        it(@"replaces two %@s with nothing", ^{
            NSString *subject = @"Check out %@ by %@";
            defaults[ARMultipleSameArtistEmailSubject] = subject;
            expect([composer subject]).toNot.contain(artwork.title);
            expect([composer subject]).toNot.contain(artwork.artist.presentableName);
        });
        
        it(@"handles untitled artworks correctly ", ^{
            defaults[AREmailSubject] = @"Check out %@ by %@";
            
            composer.artworks = @[ untitledArtwork ];
            expect([composer subject]).toNot.contain(@"(null)");
        });

    });

    describe(@"with the different artists", ^{
        beforeEach(^{
            Artist *artist = [Artist objectInContext:context];
            artist.displayName = @"Artist Name";
            artist.slug = @"artist1";

            Artist *artist2 = [Artist objectInContext:context];
            artist2.displayName = @"Artist2 Name";
            artist2.slug = @"artist2";

            artwork = [Artwork objectInContext:context];
            artwork.title = @"Artwork Name";
            artwork.artist = artist;

            artwork2 = [Artwork objectInContext:context];
            artwork2.title = @"Artwork2 Name";
            artwork2.artist = artist2;

            composer.artworks = @[ artwork, artwork2 ];
        });

        it(@"uses the default", ^{
            defaults[ARMultipleEmailSubject] = @"subject";
            [composer subject];
            expect(defaults.lastRequestedKey).to.equal(ARMultipleEmailSubject);
        });

        it(@"shows default if no %@", ^{
            NSString *subject = @"Marmite";
            defaults[ARMultipleEmailSubject] = subject;
            expect([composer subject]).to.equal(subject);
        });

        it(@"replaces one %@ with nothing", ^{
            NSString *subject = @"Check out %@";
            defaults[ARMultipleEmailSubject] = subject;
            expect([composer subject]).to.equal(@"Check out ");
        });

        it(@"replaces two %@s with nothing", ^{
            NSString *subject = @"Check out %@ by %@";
            defaults[ARMultipleEmailSubject] = subject;
            expect([composer subject]).to.equal(@"Check out  by ");
        });
    });
});

describe(@"email html", ^{
    __block Artist *artist;
    __block Artwork *artwork;
    __block Image *additionalImage;
    
    beforeEach(^{
        artist = [Artist objectInContext:context];
        artist.displayName = @"Artist Name";
        
        artwork = [Artwork objectInContext:context];
        artwork.title = @"Artwork Name";
        artwork.artist = artist;
        artwork.slug = @"slug";

        Image *mainImage = [ARModelFactory imageWithKnownRemoteResourcesInContext:context];
        mainImage.isMainImage = @(YES);
        mainImage.baseURL = @"http://static0.artsy.net/additional_images/1/";
        
        additionalImage = [ARModelFactory imageWithKnownRemoteResourcesInContext:context];
        additionalImage.isMainImage = @(NO);
        additionalImage.baseURL = @"http://static0.artsy.net/additional_images/2/";
        
        artwork.mainImage = mainImage;
        artwork.images = [NSSet setWithArray:@[mainImage, additionalImage]];
        
        composer.options = [[AREmailSettings alloc] init];
    });

    
    it(@"switches 'artwork' to 'artworks' in greeting when sending multiple artworks", ^{
        defaults[AREmailGreeting] = @"information about the artwork we discussed";
        composer.artworks = @[ artwork, artwork ];
        expect(composer.body).to.contain(@"the artworks we discussed");
    });
    
    it(@"converts newlines in signature to <br/>", ^{
        defaults[AREmailSignature] = @"Hello\nWorld";
        composer.artworks = @[ artwork ];
        expect(composer.body).to.contain(@"Hello<br/>World");
    });
    
    it(@"converts newlines in greetings to <br/>", ^{
        defaults[AREmailGreeting] = @"Hello\nWorld";
        composer.artworks = @[ artwork ];
        expect(composer.body).to.contain(@"Hello<br/>World");
    });
    
    it(@"inlines the images", ^{
        composer.artworks = @[ artwork ];
        expect(composer.body).to.contain([[artwork.mainImage imageURLWithFormatName:ARFeedImageSizeLargeKey] absoluteString]);
    });
    
    it(@"inlines additional images", ^{
        composer.artworks = @[ artwork ];
        composer.options.additionalImages = @[additionalImage];
        expect(composer.body).to.contain([[additionalImage imageURLWithFormatName:ARFeedImageSizeLargeKey] absoluteString]);
    });

    it(@"inlines installation images images", ^{
        composer.options.installationShots = @[additionalImage];
        expect(composer.body).to.contain([[additionalImage imageURLWithFormatName:ARFeedImageSizeLargeKey] absoluteString]);
    });

    it(@"inlines prices as backend images", ^{
        composer.artworks = @[ artwork ];
        composer.options.priceType = AREmailSettingsPriceTypeFront;
        artwork.displayPrice = @"123123";
        artwork.backendPrice = @"321321";
        expect(composer.body).to.contain(artwork.displayPrice);
    });

    describe(@"with an edition sets" , ^{

        it(@"with one edition set", ^{
            composer.artworks = @[ artwork ];
            composer.options.priceType = AREmailSettingsPriceTypeNoPrice;
            EditionSet *set = [EditionSet modelFromJSON:@{
                ARFeedIDKey : @"123123",
                ARFeedDimensionsKey : @{
                    ARFeedDimensionsInchesKey: @"11 inches",
                    ARFeedDimensionsCMKey: @"23cm"
                },
                ARFeedArtworkEditionsKey: @"Editions Info",
                ARFeedAvailabilityKey: @"Available Info",
                ARFeedInternalPriceKey: @"price_internal_123",
                ARFeedPriceKey: @"price_external_123"
            } inContext:context];
            artwork.editionSets = [NSSet setWithObject:set];
            
            NSString *body = composer.body;
            expect(body).to.contain(set.editions);
            expect(body).to.contain(set.dimensionsCM);
            expect(body).to.contain(set.dimensionsInches);
            expect(body).to.contain(set.availability);
            expect(body).toNot.contain(set.displayPrice);
            expect(body).toNot.contain(set.backendPrice);
        });

        it(@"with an edition set it doesnt show some artwork metadata", ^{
            composer.artworks = @[ artwork ];
            composer.options.priceType = AREmailSettingsPriceTypeBackend;
            EditionSet *set = [EditionSet modelFromJSON:@{
                ARFeedIDKey : @"123123",
                ARFeedPriceKey: @"price_external_123"
            } inContext:context];
            artwork.editionSets = [NSSet setWithObject:set];

            artwork.dimensionsCM = @"43234cm";
            artwork.dimensionsInches = @"9898inches";
            artwork.backendPrice = @"my backend price";

            NSString *body = composer.body;
            expect(body).toNot.contain(artwork.dimensionsInches);
            expect(body).toNot.contain(artwork.dimensionsCM);
            expect(body).toNot.contain(artwork.backendPrice);
        });

        it(@"shows edition prices when front end prices are enabled", ^{
            composer.artworks = @[ artwork ];
            composer.options.priceType = AREmailSettingsPriceTypeFront;

            EditionSet *set = [EditionSet modelFromJSON:@{
                ARFeedIDKey : @"123123",
                ARFeedInternalPriceKey: @"price_internal_123",
                ARFeedPriceKey: @"price_external_123"
            } inContext:context];
            artwork.editionSets = [NSSet setWithObject:set];

            expect(composer.body).to.contain(set.displayPrice);
            expect(composer.body).toNot.contain(set.backendPrice);
        });

        it(@"shows edition internal prices when back end prices are enabled", ^{
            composer.artworks = @[ artwork ];
            composer.options.priceType = AREmailSettingsPriceTypeBackend;

            EditionSet *set = [EditionSet modelFromJSON:@{
                ARFeedIDKey : @"123123",
                ARFeedInternalPriceKey: @"price_internal_123",
                ARFeedPriceKey: @"price_external_123"
            } inContext:context];
            artwork.editionSets = [NSSet setWithObject:set];
            
            expect(composer.body).to.contain(set.backendPrice);
            expect(composer.body).toNot.contain(set.displayPrice);
        });
    });


    describe(@"Shows supplementary information", ^{
        before(^{
            artwork.info = @"123";
            artwork.exhibitionHistory = @"234";
            artwork.provenance = @"345";
            artwork.literature = @"456";
            artwork.signature = @"567";
            artwork.series = @"678";
            artwork.imageRights = @"789";
            composer.artworks = @[ artwork ];
            composer.options.showSupplementaryInformation = YES;
        });

        it(@"includes the info in the email", ^{
            NSString *body = composer.body;
            expect(body).to.contain(artwork.info);
            expect(body).to.contain(artwork.exhibitionHistory);
            expect(body).to.contain(artwork.provenance);
            expect(body).to.contain(artwork.literature);
            expect(body).to.contain(artwork.signature);
            expect(body).to.contain(artwork.series);
            expect(body).to.contain(artwork.imageRights);
        });

    });

    it(@"falls back to display price if no backend price when showing backend prices images", ^{

        artwork.displayPrice = @"123123";
        artwork.backendPrice = @"321321";

        Artwork *artwork2 = [Artwork objectInContext:context];
        artwork2.title = @"Artwork Name 2";
        artwork2.displayPrice = @"456456";

        Image *mainImage = [ARModelFactory imageWithKnownRemoteResourcesInContext:context];
        mainImage.isMainImage = @(YES);
        mainImage.baseURL = @"http://static0.artsy.net/additional_images/1/";
        artwork2.mainImage = mainImage;

        composer.artworks = @[ artwork, artwork2 ];
        composer.options.priceType = AREmailSettingsPriceTypeBackend;
        NSString *body = composer.body;

        expect(body).to.contain(artwork.backendPrice);
        expect(body).to.contain(artwork2.displayPrice);
    });

});

SpecEnd

#import "ARDefaults.h"
#import "AROptions.h"
#import "NSFetchRequest+ARModels.h"

SpecBegin(NSFetchRequestARModels);

__block NSManagedObjectContext *context;
__block Artist *artist1, *artist2, *artist3;
__block Artwork *artwork1, *artwork2, *artwork3;
__block ForgeriesUserDefaults *defaults;
__block NSFetchRequest *request;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    defaults = [[ForgeriesUserDefaults alloc] init];

    artist1  = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
    artist2 = [Artist stubbedArtistWithPublishedArtworks:YES inContext:context];
    artist3 = [Artist stubbedArtistWithPublishedArtworks:NO inContext:context];
});


describe(@"all instances of a container", ^{

    it(@"returns all objects of a class", ^{
        Class klass = Artist.class;
       request = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:klass
                                                              inContext:context
                                                               defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artist1);
        expect(results).to.contain(artist2);
        expect(results).to.contain(artist3);
        expect(results).to.containInstancesOfClass(klass);
    });

    it(@"skips objects that dont have artworks", ^{
        Artist *artist4 = [Artist objectInContext:context];
        request = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Artist.class
                                                               inContext:context
                                                                defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).toNot.contain(artist4);
    });


    it(@"respects the show only available default for old settings", ^{
        defaults[ARShowAvailableOnly] = @(YES);

        Artwork *artwork = artist1.artworks.firstObject;
        artwork.isAvailableForSale = @(YES);

        request = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Artist.class
                                                               inContext:context
                                                                defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artist1);
        expect(results).toNot.contain(artist2);
        expect(results.count).to.equal(1);
    });

    it(@"respects the hide unpublished default for old settings", ^{
        defaults[ARHideUnpublishedWorks] = @(YES);
        request = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Artist.class
                                                               inContext:context
                                                                defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artist1);
        expect(results).to.contain(artist2);
        expect(results).toNot.contain(artist3);
    });

    it(@"respects the hide unavailable default in presentation mode", ^{
        defaults[AROptionsUseLabSettings] = @(YES);
        defaults[ARPresentationModeOn] = @(YES);
        defaults[ARShowAvailableOnly] = @(YES);
        
        Artwork *artwork = artist1.artworks.firstObject;
        artwork.isAvailableForSale = @(YES);
        
        request = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Artist.class
                                                               inContext:context
                                                                defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artist1);
        expect(results).toNot.contain(artist2);
        expect(results.count).to.equal(1);
    });
    
    it(@"respects the hide unpublished default in presentation mode", ^{
        defaults[AROptionsUseLabSettings] = @(YES);
        defaults[ARPresentationModeOn] = @(YES);
        defaults[ARHideUnpublishedWorks] = @(YES);
        request = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Artist.class
                                                               inContext:context
                                                                defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artist1);
        expect(results).to.contain(artist2);
        expect(results).toNot.contain(artist3);
    });

    it(@"ignores the hide unavailable default when not in presentation mode", ^{
        defaults[AROptionsUseLabSettings] = @(YES);
        defaults[ARPresentationModeOn] = @(NO);
        defaults[ARShowAvailableOnly] = @(YES);
        
        Artwork *artwork = artist1.artworks.firstObject;
        artwork.isAvailableForSale = @(YES);
        
        request = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Artist.class
                                                               inContext:context
                                                                defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artist1);
        expect(results).to.contain(artist2);
        expect(results.count).to.equal(3);
    });
    
    it(@"ignores the hide unpublished default when not in presentation mode", ^{
        defaults[AROptionsUseLabSettings] = @(YES);
        defaults[ARPresentationModeOn] = @(NO);
        defaults[ARHideUnpublishedWorks] = @(YES);
        request = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Artist.class
                                                               inContext:context
                                                                defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artist1);
        expect(results).to.contain(artist2);
        expect(results).to.contain(artist3);
    });

});

describe(@"all artworks from a container", ^{

    __block NSPredicate *scopePredicate;

    beforeEach(^{
        artwork1 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork2 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artwork3 = [Artwork stubbedArtworkWithImages:YES inContext:context];
        artist1.artworks = [NSSet setWithObjects:artwork1, artwork2, artwork3, nil];
        artist1.slug = @"danger";
        scopePredicate = [NSPredicate predicateWithFormat:@"artist.slug == %@", artist1.slug];
    });

    it(@"returns all artworks for an instance", ^{
        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];

        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artwork1);
        expect(results).to.contain(artwork2);
        expect(results).to.contain(artwork3);
        expect(results).to.containInstancesOfClass(Artwork.class);
    });


    pending(@"skips objects that dont have images", ^{
        artwork1.images = nil;

        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).toNot.contain(artwork1);
    });

    pending(@"skips objects that have an image that's processing", ^{
        Image *image = artwork1.images.firstObject;
        image.processing = @(YES);
        artwork1.images = [NSSet setWithObject:image];

        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).toNot.contain(artwork1);
    });

    it(@"respects the show only available default for old settings", ^{
        defaults[ARShowAvailableOnly] = @(YES);

        artwork1.isAvailableForSale = @(YES);
        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];

        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artwork1);
        expect(results.count).to.equal(1);
        expect(results).toNot.contain(artwork2);
    });

    it(@"respects the hide unavailable default in presentation mode", ^{
        defaults[AROptionsUseLabSettings] = @(YES);
        defaults[ARPresentationModeOn] = @(YES);
        defaults[ARShowAvailableOnly] = @(YES);
        
        artwork1.isAvailableForSale = @(YES);
        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];
        
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artwork1);
        expect(results.count).to.equal(1);
        expect(results).toNot.contain(artwork2);
    });

    it(@"ignores the hide unavailable default when not in presentation mode", ^{
        defaults[AROptionsUseLabSettings] = @(YES);
        defaults[ARPresentationModeOn] = @(NO);
        defaults[ARShowAvailableOnly] = @(YES);
        
        artwork1.isAvailableForSale = @(YES);
        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];
        
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artwork1);
        expect(results).to.contain(artwork2);
        expect(results.count).to.equal(3);
    });
    
    it(@"respects the hide unpublished default in presentation mode", ^{
        defaults[AROptionsUseLabSettings] = @(YES);
        defaults[ARPresentationModeOn] = @(YES);
        defaults[ARHideUnpublishedWorks] = @(YES);
        
        artwork1.isPublished = @(YES);
        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];
        
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artwork1);
        expect(results.count).to.equal(1);
        expect(results).toNot.contain(artwork2);
    });
    
    it(@"ignores the hide unpublished default when not in presentation mode", ^{
        defaults[AROptionsUseLabSettings] = @(YES);
        defaults[ARPresentationModeOn] = @(NO);
        defaults[ARShowAvailableOnly] = @(YES);
        
        artwork1.isPublished = @(YES);
        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];
        
        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).to.contain(artwork1);
        expect(results).to.contain(artwork2);
        expect(results.count).to.equal(3);
    });

    
    pending(@"respects the hide unpublished default", ^{
        defaults[ARHideUnpublishedWorks] = @(YES);
        artwork1.isPublished = @(NO);

        request = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:context defaults:(id)defaults];

        NSArray *results = [context executeFetchRequest:request error:nil];
        expect(results).toNot.contain(artwork1);
    });
});


SpecEnd;

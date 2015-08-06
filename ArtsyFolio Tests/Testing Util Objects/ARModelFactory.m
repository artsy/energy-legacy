#import "ARModelFactory.h"
#import "LocalImage.h"
#import "ARDefaults.h"


@implementation ARModelFactory

+ (Artwork *)partiallyFilledArtworkInContext:(NSManagedObjectContext *)context
{
    return [Artwork modelFromJSON:@{
        ARFeedDisplayTitleKey : @"Snakes and Ladders",
        ARFeedCategoryKey : @"Board Game",
        ARFeedMediumKey : @"Cardboard, plastic dice",
        ARFeedPublishedKey : @YES,
        ARFeedDateKey : @"2008",
        ARFeedArtworkInfoKey : @"Tip: You want to get the force deal cards",
        ARFeedWidthKey : @100,
        ARFeedHeightKey : @200,
        ARFeedDepthKey : @3,
        ARFeedDiameterKey : @344,
        ARFeedDimensionsInchesKey : @"100' x 100'",
        ARFeedDimensionsCMKey : @"100cm x 100cm",
    } inContext:context];
}

+ (Artwork *)fullArtworkInContext:(NSManagedObjectContext *)context
{
    return [Artwork modelFromJSON:@{
        ARFeedDisplayTitleKey : @"Monopoly Deal",
        ARFeedCategoryKey : @"Cards",
        ARFeedMediumKey : @"Paper, printing stuff",
        ARFeedPublishedKey : @YES,
        ARFeedDateKey : @"Sometime in 2014",
        ARFeedArtworkInfoKey : @"Tip: You want to get the force deal cards",
        ARFeedWidthKey : @200,
        ARFeedHeightKey : @400,
        ARFeedDepthKey : @2,
        ARFeedDiameterKey : @34,
        ARFeedAvailabilityKey : @"It's on Amazon",
        ARFeedDimensionsInchesKey : @"20' x 30'",
        ARFeedDimensionsCMKey : @"40cm x 60cm",
        ARFeedPriceKey : @"4400",
        ARFeedInternalPriceKey : @"6000",
        ARFeedPriceHiddenStateKey : @NO,
        ARFeedShowHistoryKey : @"Monopoly is a pretty old game. Might have been made in the 1800s, not really too sure. Go read wikipedia.",
        ARFeedProvenanceKey : @"Amazon",
        ARFeedArtworkInfoKey : @"Can be used as part of a series",
        ARFeedSignatureKey : @"Signed by the guy in the top hat",
        ARFeedLiteratureKey : @"See Patent Office",
        ARFeedImageRightsKey : @"Commercial",
        ARFeedSeriesKey : @"104 cards",
        ARFeedInventoryIDKey : @"monopoly-deal",
        ARFeedIDKey : @"Reggie-Mystery",
        ARFeedConfidentialNotesKey : @"Very secret special note about this work",

    } inContext:context];
}

+ (Artwork *)fullArtworkWithEditionsInContext:(NSManagedObjectContext *)context
{
    return [Artwork modelFromJSON:@{
        ARFeedDisplayTitleKey : @"Monopoly Deal",
        ARFeedCategoryKey : @"Cards",
        ARFeedMediumKey : @"Paper, printing stuff",
        ARFeedPublishedKey : @YES,
        ARFeedDateKey : @"Sometime in 2014",
        ARFeedArtworkInfoKey : @"Tip: You want to get the force deal cards",
        ARFeedWidthKey : @200,
        ARFeedHeightKey : @400,
        ARFeedDepthKey : @2,
        ARFeedDiameterKey : @34,
        ARFeedAvailabilityKey : @"It's on Amazon",
        ARFeedDimensionsInchesKey : @"20' x 30'",
        ARFeedDimensionsCMKey : @"40cm x 60cm",
        ARFeedPriceKey : @"4400",
        ARFeedInternalPriceKey : @"6000",
        ARFeedPriceHiddenStateKey : @NO,
        ARFeedShowHistoryKey : @"Monopoly is a pretty old game. Might have been made in the 1800s, not really too sure. Go read wikipedia.",
        ARFeedProvenanceKey : @"Amazon",
        ARFeedArtworkInfoKey : @"Can be used as part of a series",
        ARFeedSignatureKey : @"Signed by the guy in the top hat",
        ARFeedLiteratureKey : @"See Patent Office",
        ARFeedImageRightsKey : @"Commercial",
        ARFeedSeriesKey : @"104 cards",
        ARFeedInventoryIDKey : @"monopoly-deal",
        ARFeedIDKey : @"Reggie-Mystery",
        ARFeedConfidentialNotesKey : @"Very secret special note about this work",
        ARFeedArtworkEditionSetsKey : @[
            @{
               ARFeedArtworkEditionsKey : @"Edition of 222",
               ARFeedInternalPriceKey : @"$4200",
               ARFeedAvailabilityKey : @"For Sale",
            },
            @{
               ARFeedArtworkEditionsKey : @"Edition of 222",
               ARFeedInternalPriceKey : @"$4200",
               ARFeedAvailabilityKey : @"For Sale",
            },
        ],
    } inContext:context];
}

+ (Artist *)filledArtistInContext:(NSManagedObjectContext *)context
{
    return [Artist modelFromJSON:@{
        ARFeedYearsKey : @"1995",
        ARFeedDeathDateKey : @"2014-07-21T09:10:37+00:00",
        ARFeedIDKey : @"Reggie-Mystery",
        ARFeedNameKey : @"Reggie P Mystery",
        ARFeedFirstNameKey : @"Reginald",
        ARFeedMiddleNameKey : @"Percy",
        ARFeedLastNameKey : @"Mystery",
        ARFeedDisplayNameKey : @"Mr Reggie Mystery",
        ARFeedAwardsKey : @"Won some awards in his later years.",
        ARFeedBlurbKey : @"Did some interesting work around refactoring.",
        ARFeedHometownKey : @"Huddersfield, UK",
        ARFeedBiographyKey : @"Won some awards, did some stuff, people liked him.",
        ARFeedNationalityKey : @"British",
        ARFeedStatementKey : @"Spiffing",
        ARFeedSortableIDKey : @"mystery-reginald"
    } inContext:context];
}


+ (void)addLocalImagesToArtwork:(Artwork *)artwork
{
    LocalImage *image = [LocalImage objectInContext:artwork.managedObjectContext];
    LocalImage *image2 = [LocalImage objectInContext:artwork.managedObjectContext];

    NSString *localImagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"example-image" ofType:@"png"];
    image.imageFilePath = localImagePath;
    image2.imageFilePath = localImagePath;

    image.artwork = artwork;
    image2.artwork = artwork;

    artwork.images = [NSSet setWithArray:@[ image, image2 ]];
    artwork.mainImage = image;
}

+ (Image *)imageWithKnownRemoteResourcesInContext:(NSManagedObjectContext *)context
{
    return [Image modelFromJSON:@{
        ARFeedImageSourceKey : @"http://static0.artsy.net/additional_images/519d3bb4275b249173000070/",
        ARFeedSlugKey : @"519d3bb4275b249173000070",
        ARFeedIDKey : @"519d3bb4275b249173000070"
    } inContext:context];
}

+ (User *)createCurrentUserInContext:(NSManagedObjectContext *)context
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [User modelFromJSON:@{ ARFeedEmailKey : [defaults
                                      objectForKey:ARUserEmailAddress] }
                     inContext:context];
}

@end

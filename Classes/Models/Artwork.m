#import "ARFeedTranslator.h"
#import "NSDictionary+ObjectForKey.h"

#import "NSString+NiceFractions.h"
#import "EditionSet.h"

static const int NumberOfCharactersInArtworkTitleBeforeCrop = 17;


@implementation Artwork

- (NSString *)description
{
    return [NSString stringWithFormat:@"Artwork : %@ ( by %@ )", self.title, self.artistDisplayString];
}

- (void)updateWithDictionary:(NSDictionary *)aDictionary
{
    self.title = [aDictionary onlyStringForKey:ARFeedTitleKey];

    if ([aDictionary onlyArrayForKey:ARFeedArtistsKey].count > 0) {
        NSArray<Artist *> *artists = [ARFeedTranslator addOrUpdateObjects:[aDictionary onlyArrayForKey:ARFeedArtistsKey] withEntityName:@"Artist" inContext:self.managedObjectContext saving:NO];
        self.artists = [NSSet setWithArray:artists];

    } else {
        // Create an unknown artist.
        Artist *unknownArtist = [Artist findOrCreateUnknownArtistInContext:self.managedObjectContext];
        self.artists = [NSSet setWithObject:unknownArtist];
    }

    if ([aDictionary onlyArrayForKey:ARFeedImagesKey]) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSDictionary *imageDict in [aDictionary onlyArrayForKey:ARFeedImagesKey]) {
            if (imageDict[ARFeedIDKey]) {
                NSMutableDictionary *imageDictWithID = [imageDict mutableCopy];
                imageDictWithID[ARFeedArtworkIDKey] = self.slug;
                [images addObject:imageDictWithID];
            } else {
                [ARAnalytics event:@"Error - no ID for images on Artwork" withProperties:@{ @"artwork" : self.title,
                                                                                            @"artist" : self.artistDisplayString }];
            }
        }

        [ARFeedTranslator addOrUpdateObjects:images
                              withEntityName:@"Image"
                                   inContext:self.managedObjectContext
                                      saving:NO];
    }

    NSArray *editionSetDicts = [aDictionary onlyArrayForKey:ARFeedArtworkEditionSetsKey];
    if (editionSetDicts.count) {
        NSArray *editionSets = [editionSetDicts map:^(NSDictionary *dict) {
            EditionSet *set = [EditionSet createInContext:self.managedObjectContext];
            [set updateWithDictionary:dict];
            return set;
        }];

        self.editionSets = [NSSet setWithArray:editionSets];
    }

    self.displayTitle = [aDictionary onlyStringForKey:ARFeedDisplayTitleKey];
    self.category = [aDictionary onlyStringForKey:ARFeedCategoryKey];
    self.medium = [aDictionary onlyStringForKey:ARFeedMediumKey];
    self.isPublished = [aDictionary objectForKeyNotNull:ARFeedPublishedKey];

    self.date = [aDictionary onlyStringForKey:ARFeedDateKey];

    self.width = [aDictionary onlyDecimalForKey:ARFeedWidthKey];
    self.height = [aDictionary onlyDecimalForKey:ARFeedHeightKey];
    self.depth = [aDictionary onlyDecimalForKey:ARFeedDepthKey];
    self.diameter = [aDictionary onlyDecimalForKey:ARFeedDiameterKey];

    /// The metric field in the response will be either 'cm' or 'in', so if it's 'cm', dimensions should be converted to inches. Hopefully, these are the only two systems of measurement we need to support in Folio for a long time.
    BOOL shouldConvertToInches = [[aDictionary onlyStringForKey:ARFeedMetricKey] isEqualToString:@"cm"];
    if (shouldConvertToInches) [self convertDimensionsToAmericanSystemOfMeasurement];

    self.availability = [aDictionary onlyStringForKey:ARFeedAvailabilityKey];
    self.isAvailableForSale = @([self.availability isEqualToString:@"for sale"]);

    NSDictionary *dimensions = [aDictionary onlyDictionaryForKey:ARFeedDimensionsKey];
    if (dimensions) {
        self.dimensionsInches = [dimensions onlyStringForKey:ARFeedDimensionsInchesKey];
        self.dimensionsCM = [dimensions onlyStringForKey:ARFeedDimensionsCMKey];
    }

    self.displayPrice = [aDictionary onlyStringForKey:ARFeedPriceKey];
    self.backendPrice = [aDictionary onlyStringForKey:ARFeedInternalPriceKey];

    self.isPriceHidden = [aDictionary objectForKeyNotNull:ARFeedPriceHiddenStateKey];

    self.exhibitionHistory = [aDictionary onlyStringForKey:ARFeedShowHistoryKey];
    self.provenance = [aDictionary onlyStringForKey:ARFeedProvenanceKey];
    self.info = [aDictionary onlyStringForKey:ARFeedArtworkInfoKey];
    self.signature = [aDictionary onlyStringForKey:ARFeedSignatureKey];
    self.literature = [aDictionary onlyStringForKey:ARFeedLiteratureKey];
    self.imageRights = [aDictionary onlyStringForKey:ARFeedImageRightsKey];
    self.series = [aDictionary onlyStringForKey:ARFeedSeriesKey];
    self.inventoryID = [aDictionary onlyStringForKey:ARFeedInventoryIDKey];
    self.confidentialNotes = [aDictionary onlyStringForKey:ARFeedConfidentialNotesKey];
    self.artistOrderingKey = [self artistOrderingString];
}

- (ARArtworkAvailability)availabilityState
{
    NSString *availability = self.availability;
    if ([availability isEqualToString:@"not for sale"]) {
        return ARArtworkAvailabilityNotForSale;
    } else if ([availability isEqualToString:@"for sale"]) {
        return ARArtworkAvailabilityForSale;
    } else if ([availability isEqualToString:@"sold"]) {
        return ARArtworkAvailabilitySold;
    } else if ([availability isEqualToString:@"on loan"]) {
        return ARArtworkAvailabilityOnLoan;
    } else if ([availability isEqualToString:@"permanent collection"]) {
        return ARArtworkAvailabilityPermenentCollection;
    } else {
        return ARArtworkAvailabilityOnHold;
    }
}

- (ARArtworkAvailability)looseAvailabilityState
{
    // If there's no editions just use the main artwork response
    if (!self.editionSets.count) {
        return [self availabilityState];
    }
    // Prioritise anything being available
    for (EditionSet *set in self.editionSets) {
        if (set.isAvailableForSale) {
            return ARArtworkAvailabilityForSale;
        }
    }
    // Allow it to fall back to the main artwork
    return [self availabilityState];
}

- (UIColor *)colorForAvailabilityState:(ARArtworkAvailability)availablity
{
    switch (availablity) {
        case ARArtworkAvailabilityForSale: // Green
            return [UIColor colorWithRed:0 green:165 / 255.0 blue:44 / 255.0 alpha:1];
        case ARArtworkAvailabilityOnHold: // Orange
            return [UIColor colorWithRed:1 green:163 / 255.0 blue:0 / 255.0 alpha:1];
        case ARArtworkAvailabilitySold: // Red
            return [UIColor colorWithRed:219 / 255.0 green:1 / 255.0 blue:0 / 255.0 alpha:1];
        case ARArtworkAvailabilityNotForSale:
        case ARArtworkAvailabilityOnLoan:
        case ARArtworkAvailabilityPermenentCollection: // Grey
            return [UIColor colorWithRed:165 / 255.0 green:165 / 255.0 blue:165 / 255.0 alpha:1];
    }
}

- (void)convertDimensionsToAmericanSystemOfMeasurement
{
    self.width = [self convertFromCMToIN:self.width];
    self.height = [self convertFromCMToIN:self.height];
    self.diameter = [self convertFromCMToIN:self.diameter];
    self.depth = [self convertFromCMToIN:self.depth];
}

- (NSDecimalNumber *)convertFromCMToIN:(NSDecimalNumber *)value
{
    NSNumber *inches = @([value floatValue] / 2.54);
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", inches]];
}

- (void)willSave
{
    if (!self.mainImage && self.images.count > 0) {
        self.mainImage = [self.images anyObject];
    }

    for (Image *image in self.images) {
        if ((self.mainImage == image) && [image.position intValue] != 0) {
            [self moveImageToFirstPosition:image];
            break;
        }
    }
}

- (NSArray *)sortedImages
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:descriptor, nil];
    return [self.images sortedArrayUsingDescriptors:descriptors];
}

- (void)moveImageToFirstPosition:(Image *)mainImage
{
    for (Image *anImage in self.images) {
        if (anImage == mainImage) {
            continue;
        }
        if ([anImage.position intValue] == 0) {
            anImage.position = [mainImage.position copy];
        }
        mainImage.position = @0;
    }
}

- (BOOL)hasAdditionalInfo
{
    return self.info.length || self.exhibitionHistory.length || self.provenance.length || self.literature.length || self.signature.length || self.series.length || self.imageRights.length || self.inventoryID.length;
}

// This differs from hasAdditionalInfo
// by not checking for an inventory ID
// it's used by the AREmailArtworksVC

- (BOOL)hasSupplementaryInfo
{
    return self.info.length || self.exhibitionHistory.length || self.provenance.length || self.literature.length || self.signature.length || self.series.length || self.imageRights.length;
}

- (NSString *)dimensions
{
    if (!self.dimensionsCM) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@ — %@", [NSString stringByMakingFractionsLookNice:self.dimensionsInches], self.dimensionsCM];
}

- (NSString *)alternativeDimensions
{
    if (!self.dimensionsCM) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@ — %@", self.dimensionsCM, [NSString stringByMakingFractionsLookNice:self.dimensionsInches]];
}

- (NSString *)internalPrice
{
    if ([self.backendPrice length]) {
        return self.backendPrice;
    } else if ([self.displayPrice length]) {
        return self.displayPrice;
    } else {
        return nil;
    }
}

- (float)aspectRatio
{
    return [[[self mainImage] aspectRatio] floatValue];
}

- (NSString *)gridThumbnailPath:(NSString *)size
{
    return [[self mainImage] imagePathWithFormatName:size];
}

- (NSURL *)gridThumbnailURL:(NSString *)size
{
    return [[self mainImage] imageURLWithFormatName:size];
}

- (NSString *)gridTitle
{
    return self.artistDisplayString;
}

- (NSUInteger)collectionSize
{
    return 1;
}

- (NSString *)gridSubtitle
{
    // The idea format is name + date, with a comma + space.
    // if we can't get that we crop name to ~20 chars then add date

    NSString *subtitle = nil;
    NSString *title = self.title.length ? self.title : @"Untitled";

    BOOL needsCrop = title.length > NumberOfCharactersInArtworkTitleBeforeCrop;
    NSInteger cropCount = MIN(title.length, NumberOfCharactersInArtworkTitleBeforeCrop);
    subtitle = [title substringToIndex:cropCount];

    if (subtitle) {
        // if it's got a date append it
        if (self.date && ![self.date isEqualToString:@""]) {
            if (needsCrop) {
                subtitle = [NSString stringWithFormat:@"%@…, %@", subtitle, self.date];
            } else {
                subtitle = [NSString stringWithFormat:@"%@, %@", subtitle, self.date];
            }
        } else {
            // if we've cropped we should add an ellipsis
            if (needsCrop) {
                subtitle = [NSString stringWithFormat:@"%@…", subtitle];
            }
        }
    }

    return subtitle;
}

- (NSAttributedString *)attributedGridSubtitle
{
    NSString *original = self.gridSubtitle;

    // This aint a good dependency in this function
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Just return the original string as an attirbuted string when we're not adding a dot
    if ([defaults boolForKey:ARPresentationModeOn] && [defaults boolForKey:ARHideArtworkAvailability]) {
        return [[NSAttributedString alloc] initWithString:original];
    }

    // Start with the original string: [artwork, date]
    // Add a dot: [artwork, date ●]
    NSString *fullString = [original stringByAppendingString:@" •"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:fullString];

    // Color and size that dot
    UIColor *color = [self colorForAvailabilityState:self.availabilityState];
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(original.length + 1, 1)];
    [string addAttribute:NSFontAttributeName value:[UIFont serifItalicFontWithSize:22] range:NSMakeRange(original.length + 1, 1)];

    return string;
}


- (BOOL)hasAdditionalImages
{
    return self.images.count > 1;
}

- (NSString *)availabilityString
{
    return [self.availability capitalizedString];
}

- (void)deleteArtwork
{
    NSArray *imagesCopy = [self.images copy];
    for (Image *image in imagesCopy) {
        [image deleteImage];
    }
    [self deleteEntity];
}

- (NSString *)titleForEmail
{
    return [self gridSubtitle];
}

static NSSortDescriptor *ARSortDisplayDescriptor;

- (NSString *)artistDisplayString
{
    if (!ARSortDisplayDescriptor) {
        ARSortDisplayDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderingKey" ascending:YES];
    }

    return [[[self.artists sortedArrayUsingDescriptors:@[ ARSortDisplayDescriptor ]] map:^id(Artist *artist) {
        return artist.presentableName;
    }] join:@", "] ?
        :
        @"";
}

- (NSString *)artistOrderingString
{
    if (!ARSortDisplayDescriptor) {
        ARSortDisplayDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderingKey" ascending:YES];
    }

    Artist *artist = [[self.artists sortedArrayUsingDescriptors:@[ ARSortDisplayDescriptor ]] firstObject];
    return [artist orderingKey] ?: @"1";
}


+ (NSFetchedResultsController *)allArtworksInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self.class requestAllSortedBy:@keypath(Artwork.new, title) ascending:YES inContext:context];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

/// To deprecate a method you need to have an implementation

- (Artist *)artist
{
    return [super artist];
}


- (NSString *)editions
{
    return [super editions];
}

@end

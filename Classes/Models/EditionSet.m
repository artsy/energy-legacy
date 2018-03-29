#import "EditionSet.h"
#import "ARFeedKeys.h"
#import "NSDictionary+ObjectForKey.h"
#import "AREmailSettings.h"


@implementation EditionSet

- (void)updateWithDictionary:(NSDictionary *)json
{
    self.slug = [json onlyStringForKey:ARFeedIDKey];
    self.artistProofs = [json onlyStringForKey:ARFeedEditionSetArtistProofsKey];
    self.prototypes = [json onlyStringForKey:ARFeedEditionSetPrototypesKey];

    self.depth = [json onlyDecimalForKey:ARFeedDepthKey];
    self.diameter = [json onlyDecimalForKey:ARFeedDiameterKey];
    self.height = [json onlyDecimalForKey:ARFeedHeightKey];
    self.width = [json onlyDecimalForKey:ARFeedWidthKey];
    self.duration = [json onlyStringForKey:ARFeedDurationKey];

    NSDictionary *dimensions = [json onlyDictionaryForKey:ARFeedDimensionsKey];
    if (dimensions) {
        self.dimensionsInches = [dimensions onlyStringForKey:ARFeedDimensionsInchesKey];
        self.dimensionsCM = [dimensions onlyStringForKey:ARFeedDimensionsCMKey];
    }

    self.backendPrice = [json onlyStringForKey:ARFeedInternalPriceKey];
    self.displayPrice = [json onlyStringForKey:ARFeedPriceKey];
    self.isPriceHidden = [json objectForKeyNotNull:ARFeedPriceHiddenStateKey];

    self.editionSize = [json onlyStringForKey:ARFeedEditionSetEditionSizeKey];
    self.editions = [json onlyStringForKey:ARFeedArtworkEditionsKey];

    self.availability = [json onlyStringForKey:ARFeedAvailabilityKey];
    self.isAvailableForSale = @([self.availability isEqualToString:@"for sale"]);
    self.availableEditions = [json onlyStringForKey:ARFeedEditionSetAvailableEditionsKey];
}

- (NSArray *)editionAttributes
{
    NSMutableArray *attributes = [NSMutableArray array];
    if (self.dimensionsInches.length) [attributes addObject:self.dimensionsInches];
    if (self.dimensionsCM.length) [attributes addObject:self.dimensionsCM];
    if (self.editionSize.length > 1) [attributes addObject:self.editionSize];
    if (self.availability.length) [attributes addObject:[self.availability capitalizedString]];
    return [NSArray arrayWithArray:attributes];
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

- (NSString *)editionSize
{
    if (self.editions)
        return self.editions;
    else
        return NSLocalizedString(@"Edition Size Unspecified", @"Edition size not provided by partner");
}

- (NSString *)renderForMustacheTag:(GRMustacheTag *)tag
                           context:(GRMustacheContext *)context
                          HTMLSafe:(BOOL *)HTMLSafe
                             error:(NSError **)error
{
    AREmailSettings *settings = [context valueForMustacheKey:@"options"];
    NSAssert(settings, @"Found no 'options' in the global mustache context for rending editions");

    *HTMLSafe = YES;
    NSArray *editionAttributes = [self editionAttributes];

    if (settings.showBackendPrice && self.internalPrice.length) {
        editionAttributes = [editionAttributes arrayByAddingObject:self.internalPrice];
    } else if (settings.showPrice && self.displayPrice.length) {
        editionAttributes = [editionAttributes arrayByAddingObject:self.displayPrice];
    }

    return [editionAttributes reduce:[NSMutableString string] withBlock:^id(NSMutableString *accumulator, NSString *attribute) {
        [accumulator appendFormat:@"%@</br>", attribute];
        return accumulator;
    }];
}

@end

#import "_EditionSet.h"
#import <GRMustache/GRMustache.h>

@class Artwork;


@interface EditionSet : _EditionSet <GRMustacheRendering>

- (void)updateWithDictionary:(NSDictionary *)dictionary;

/// Aims to be the "canonical description" for the edition set
- (NSString *)displayDescription;

/// An array of the display attributes for an edition set
/// Note: Does not include price information
- (NSArray *)editionAttributes;

/// Price used by Partner (may or may not be available to the public)
- (NSString *)internalPrice;

/// Edition size (i.e. "Edition of 10"). If this isn't provided by CMS, this returns "Edition Size Unspecified"
- (NSString *)editionSize;

/// What iis it's purchased state
- (ARArtworkAvailability)availabilityState;

@end

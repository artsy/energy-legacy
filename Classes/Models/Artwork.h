#import "_Artwork.h"
#import "ARManagedObject.h"
#import "ARGridViewItem.h"

@class Image;

// https://github.com/artsy/gravity/blob/master/app/models/domain/availability.rb

typedef NS_ENUM(NSInteger, ARArtworkAvailability) {
    ARArtworkAvailabilityNotForSale,
    ARArtworkAvailabilityForSale,
    ARArtworkAvailabilityOnHold,
    ARArtworkAvailabilityOnLoan,
    ARArtworkAvailabilityPermenentCollection,
    ARArtworkAvailabilitySold,
};


@interface Artwork : _Artwork <ARGridViewItem, ARMultipleSelectionItem>

/// Use `artists` instead, keeping around to ensure backwards compatability.
- (Artist *)artist DEPRECATED_ATTRIBUTE;

/// Use `editionSets` instead
- (NSString *)editions DEPRECATED_ATTRIBUTE;

- (NSArray *)sortedImages;

- (BOOL)hasAdditionalInfo;

- (BOOL)hasSupplementaryInfo;

- (NSString *)dimensions;

- (NSString *)alternativeDimensions;

- (NSString *)availabilityString;

/// Notes whether this main artwork is for sale
- (ARArtworkAvailability)availabilityState;

/// Notes whether this main artwork, or any edition is for sale
- (ARArtworkAvailability)looseAvailabilityState;

- (NSString *)titleForEmail;

/// Display string for the titles of an Artwork, can handle multiple artists
- (NSString *)artistDisplayString;

/// A string for ordering a set of artworks based on their their artists' ordering key
- (NSString *)artistOrderingString;

/// Price used by Partner (may or may not be available to the public)
- (NSString *)internalPrice;

- (BOOL)hasAdditionalImages;

- (void)deleteArtwork;

+ (NSFetchedResultsController *)allArtworksInContext:(NSManagedObjectContext *)context;

@end

#import "_Artwork.h"
#import "ARManagedObject.h"
#import "ARGridViewItem.h"

@class Image;

// https://github.com/artsy/gravity/blob/main/app/models/domain/availability.rb

typedef NS_ENUM(NSInteger, ARArtworkAvailability) {
    ARArtworkAvailabilityForSale,
    ARArtworkAvailabilityOnHold,
    ARArtworkAvailabilitySold,
    ARArtworkAvailabilityNotForSale,
    ARArtworkAvailabilityOnLoan,
    ARArtworkAvailabilityPermenentCollection,
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

/// Notes whether main artwork, or the summary of its editions are for sale
- (ARArtworkAvailability)availabilityState;

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

// Maybe this shouldn't live in here, but for now this is fine
+ (UIColor *)colorForAvailabilityState:(ARArtworkAvailability)availablity;

/// Converts gravity string into concrete types
+ (ARArtworkAvailability)availabilityStateForString:(NSString *)string;

/// Converts from the concrete type back to the gravity string
+ (NSString *)stringForAvailabilityState:(ARArtworkAvailability)availability;

@end

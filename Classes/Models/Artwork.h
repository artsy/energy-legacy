#import "_Artwork.h"
#import "ARManagedObject.h"
#import "ARGridViewItem.h"

@class Image;


@interface Artwork : _Artwork <ARGridViewItem, ARMultipleSelectionItem>

- (NSArray *)sortedImages;

- (BOOL)hasAdditionalInfo;

- (BOOL)hasSupplementaryInfo;

- (NSString *)dimensions;

- (NSString *)alternativeDimensions;

- (NSString *)availabilityString;

- (NSString *)titleForEmail;

/// Price used by Partner (may or may not be available to the public)
- (NSString *)internalPrice;

- (BOOL)hasAdditionalImages;

- (void)deleteArtwork;

+ (NSFetchedResultsController *)allArtworksInContext:(NSManagedObjectContext *)context;

@end

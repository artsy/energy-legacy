#import "_Show.h"
#import "ARManagedObject.h"
#import "ARGridViewItem.h"
#import "ARDocumentContainer.h"
#import "ARArtworkContainer.h"

@class Artist, Artwork;


@interface Show : _Show <ARGridViewItem, ARDocumentContainer, ARArtworkContainer>

@property (strong, nonatomic) NSSet *artworkSlugs;
;

+ (NSFetchRequest *)allShowsFetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSArray *)sortDescriptorsForDates;

- (NSFetchRequest *)sortedArtworksFetchRequest;
- (NSFetchRequest *)installationShotsFetchRequestInContext:(NSManagedObjectContext *)context;

- (NSString *)presentableName;
- (void)updateArtists;
@end

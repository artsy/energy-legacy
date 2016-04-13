#import "_Album.h"
#import "ARGridViewItem.h"

#import "ARArtworkContainer.h"
#import "ARDocumentContainer.h"

@class Artwork, Artist;


@interface Album : _Album <ARGridViewItem, ARDocumentContainer, ARArtworkContainer>

@property (strong, nonatomic) NSSet *artworkSlugs;

+ (Album *)createOrFindAlbumInContext:(NSManagedObjectContext *)context slug:(NSString *)slug;

+ (NSFetchRequest *)allAlbumsFetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSArray *)editableAlbumsByLastUpdateInContext:(NSManagedObjectContext *)context;

+ (NSArray *)downloadedAlbumsInContext:(NSManagedObjectContext *)context;

- (void)updateArtists;

/// This is a version of the slug that will always have a prefixed partner ID
- (NSString *)publicSlug;

@end

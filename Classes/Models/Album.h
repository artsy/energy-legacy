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
@end

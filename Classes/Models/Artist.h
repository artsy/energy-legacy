#import "_Artist.h"

#import "ARManagedObject.h"
#import "ARGridViewItem.h"
#import "ARDocumentContainer.h"
#import "ARArtworkContainer.h"

@class Image, Document, Show, Album, Artwork;


@interface Artist : _Artist <ARGridViewItem, ARDocumentContainer, ARArtworkContainer> {
    NSDateFormatter *dateFormatter;
}

- (NSString *)searchDisplayName;

- (NSString *)presentableName;

- (BOOL)hasDocuments;

+ (NSFetchRequest *)allArtistsFetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)allArtistsFetchRequestInContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults;

- (NSFetchRequest *)showsFeaturingArtistFetchRequest;

- (NSFetchRequest *)albumsFeaturingArtistFetchRequest;

@end

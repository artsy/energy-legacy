#import <MacTypes.h>
#import "ARFeedTranslator.h"
#import "NSDictionary+ObjectForKey.h"
#import "ARSortDefinition.h"
#import "ARSortCache.h"
#import "NSFetchRequest+ARModels.h"
#import "ARSortOrderHost.h"


@implementation Album

@synthesize artworkSlugs;

+ (Album *)createOrFindAlbumInContext:(NSManagedObjectContext *)context slug:(NSString *)slug
{
    Album *album = [Album findFirstByAttribute:@"slug" withValue:slug inContext:context];
    if (!album) {
        album = [Album createInContext:context];
        album.slug = slug;
    }
    return album;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Album : %@ ( %@ artworks )", self.name, @(self.artworks.count)];
}

- (void)updateWithDictionary:(NSDictionary *)aDictionary
{
    self.name = [aDictionary onlyStringForKey:ARFeedNameKey];
    self.isPrivate = aDictionary[ARFeedPrivateStateKey];
    self.summary = [aDictionary onlyStringForKey:ARFeedSummaryKey];

    NSArray *artworksDicts = aDictionary[ARFeedArtworksKey];
    if (artworksDicts) {
        NSArray *artworks = [ARFeedTranslator addOrUpdateObjects:artworksDicts
                                                  withEntityName:@"Artwork"
                                                       inContext:self.managedObjectContext
                                                          saving:NO];
        NSSet *artworksSet = [[NSSet alloc] initWithArray:artworks];
        [self addArtworks:artworksSet];

        [self updateArtists];
    }
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];

    if ([self.slug isEqualToString:@"unknown-album"]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
        self.slug = [NSString stringWithFormat:@"%@-%@",
                                               [[name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"],
                                               uuidString];
        CFRelease(uuidString);
        CFRelease(uuid);
    }

    [self setPrimitiveValue:name forKey:@"name"];
    [self didChangeValueForKey:@"name"];
}

- (void)updateArtists
{
    NSMutableSet *artists = [NSMutableSet set];
    [self.artworks each:^(Artwork *artwork) {
        NSSet *artworkArtists = artwork.artists.count ? artwork.artists : [NSSet setWithObject:artwork.artist];
        [artists addObjectsFromArray:artworkArtists.allObjects];
    }];
    self.artists = artists;
}

- (Image *)gridThumbnailImage
{
    if (self.cover) return self.cover;

    if ([self collectionSize] > 0) {
        return [[self firstArtwork] mainImage];
    }
    return nil;
}

- (void)willSave
{
    if (!self.name) {
        self.name = @"Untitled Album";
    }
}

- (float)aspectRatio
{
    Image *thumb = [self gridThumbnailImage];
    if (thumb) {
        return [thumb.aspectRatio floatValue];
    } else {
        return 1;
    }
}

- (NSString *)gridThumbnailPath:(NSString *)size
{
    Image *thumbnail = [self gridThumbnailImage];
    if (thumbnail) {
        return [thumbnail imagePathWithFormatName:size];
    }
    return [[NSBundle mainBundle] pathForResource:@"AlbumIcon(Noartwork)" ofType:@"png"];
}

- (NSURL *)gridThumbnailURL:(NSString *)size
{
    Image *thumbnail = [self gridThumbnailImage];
    if (thumbnail) {
        return [thumbnail imageURLWithFormatName:size];
    }
    return [[NSBundle mainBundle] URLForResource:@"AlbumIcon(Noartwork)" withExtension:@"png"];
}

- (NSFetchRequest *)sortedDocumentsFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [Document entityInManagedObjectContext:context];

    // I'm not sure how this is for speed. But it works.
    req.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@ AND hasFile == YES", self.documents];

    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES] ];
    return req;
}

- (NSArray *)sortedDocuments
{
    return [self.managedObjectContext executeFetchRequest:[self sortedDocumentsFetchRequestInContext:self.managedObjectContext] error:nil];
}

- (NSFetchRequest *)artworksFetchRequestSortedBy:(ARArtworkSortOrder)order
{
    NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"ANY collections == %@", self];

    NSFetchRequest *req = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:self.managedObjectContext defaults:NSUserDefaults.standardUserDefaults];
    req.sortDescriptors = [ARSortOrderHost sortDescriptorstWithOrder:order];
    ;
    return req;
}

- (NSArray *)availableSorts
{
    // we don't want artist sorts when we only have 1 artist
    return (self.artists.count == 1) ? [ARSortOrderHost defaultSortsWithoutArtist] : [ARSortOrderHost defaultSorts];
}

- (NSFetchRequest *)sortedArtworksFetchRequest
{
    ARArtworkSortOrder order = [ARSortCache sortOrderForObjectWithSlug:self.slug];
    if (order == ARArtworksSortOrderNotFound) {
        order = ARArtworksSortOrderDefault;
    }
    return [self artworksFetchRequestSortedBy:order];
}

- (Artwork *)firstArtwork
{
    NSFetchRequest *fetch = [self sortedArtworksFetchRequest];
    [fetch setFetchLimit:1];
    return [[self.managedObjectContext executeFetchRequest:fetch error:nil] firstObject];
}

- (NSString *)gridTitle
{
    if (self.name) {
        return self.name;
    }
    return @"Unnamed Album";
}

- (NSUInteger)collectionSize
{
    return [self.managedObjectContext countForFetchRequest:[self sortedArtworksFetchRequest] error:nil];
}

- (NSString *)gridSubtitle
{
    NSInteger artworksCount = self.collectionSize;
    NSString *suffix = artworksCount > 1 ? @"s" : @"";
    return [NSString stringWithFormat:@"%@ artwork%@", @(artworksCount), suffix];
}

+ (NSFetchRequest *)allAlbumsFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:self inContext:context defaults:NSUserDefaults.standardUserDefaults];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"editable" ascending:YES],
                             [NSSortDescriptor sortDescriptorWithKey:@"sortKey" ascending:YES],
                             [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    return req;
}

+ (NSArray *)editableAlbumsByLastUpdateInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *allAlbums = [[NSFetchRequest alloc] init];
    allAlbums.entity = [NSEntityDescription entityForName:@"Album" inManagedObjectContext:context];
    allAlbums.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO] ];

    NSArray *albums = [context executeFetchRequest:allAlbums error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"editable = YES"];
    return [albums filteredArrayUsingPredicate:predicate];
}

+ (NSArray *)downloadedAlbumsInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *allAlbums = [self allAlbumsFetchRequestInContext:context];
    NSArray *albums = [context executeFetchRequest:allAlbums error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"editable = NO AND slug != 'all_artworks'"];
    return [albums filteredArrayUsingPredicate:predicate];
}

@end

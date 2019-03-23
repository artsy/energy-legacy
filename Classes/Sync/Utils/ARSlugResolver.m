#import "ARSlugResolver.h"
#import "Partner+InventoryHelpers.h"

@interface ARSlugResolver ()
@end


@implementation ARSlugResolver

- (void)syncDidFinish:(ARSync *)sync
{
    [self resolveSlugsForShows:sync.config.managedObjectContext];
    [self resolveSlugsForAlbums:sync.config.managedObjectContext];
    [self resolveSlugsForLocations:sync.config.managedObjectContext];
}

// We cannot use the default accessors for the classes because
// they have predicates on artwork count, and the defaults system

- (NSArray *)allObjectsOfClass:(Class)klass inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:context];

    return [context executeFetchRequest:req error:nil];
}

- (void)resolveSlugsForAlbums:(NSManagedObjectContext *)context
{
    NSArray *allAlbums = [self allObjectsOfClass:Album.class inContext:context];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"editable = YES"];
    NSArray *downloadedAlbums = [allAlbums filteredArrayUsingPredicate:predicate];
    [self mapSlugsToArtworksForArtworkContainerArray:downloadedAlbums inContext:context];
    [downloadedAlbums makeObjectsPerformSelector:@selector(updateArtists)];

    Album *allArtworksAlbum = [Album createOrFindAlbumInContext:context slug:@"all_artworks"];
    allArtworksAlbum.name = NSLocalizedString(@"All Artworks", @"All Artworks Album title");
    allArtworksAlbum.artworks = [NSSet setWithArray:[Artwork findAllInContext:context]];
    allArtworksAlbum.editable = @(NO);

    if ([[Partner currentPartnerInContext:context] hasForSaleWorks]) {
        Album *forSaleWorksAlbum = [Album createOrFindAlbumInContext:context slug:@"for_sale_works"];
        forSaleWorksAlbum.name = NSLocalizedString(@"For Sale Works", @"For Sale Works Album Title");
        forSaleWorksAlbum.editable = @(NO);

        NSPredicate *forSaleWorks = [NSPredicate predicateWithFormat:@"isAvailableForSale = YES"];
        forSaleWorksAlbum.artworks = [NSSet setWithArray:[Artwork findAllWithPredicate:forSaleWorks inContext:context]];
    }
}

- (void)resolveSlugsForShows:(NSManagedObjectContext *)context
{
    NSArray *allShows = [self allObjectsOfClass:Show.class inContext:context];
    [self mapSlugsToArtworksForArtworkContainerArray:allShows inContext:context];
    [allShows makeObjectsPerformSelector:@selector(updateArtists)];
}

- (void)resolveSlugsForLocations:(NSManagedObjectContext *)context
{
    NSArray *allLocations = [self allObjectsOfClass:Location.class inContext:context];
    [self mapSlugsToArtworksForArtworkContainerArray:allLocations inContext:context];
}

- (void)mapSlugsToArtworksForArtworkContainerArray:(NSArray *)objects inContext:(NSManagedObjectContext *)context
{
    [objects each:^(id container) {

        NSMutableSet *artworks = [NSMutableSet set];

        [[container artworkSlugs] each:^(NSString *slug) {
            Artwork *artwork = [[Artwork findByAttribute:@"slug" withValue:slug inContext:context] firstObject];
            if (artwork) {
                [artworks addObject:artwork];
            } else {
                ARSyncLog(@"Found a slug without a corrosponding artwork object: %@", slug);
            }
        }];

        if ([container respondsToSelector:@selector(setArtworks:)]) {
            [container setArtworks:[NSSet setWithSet:artworks]];
        }
    }];
}

@end

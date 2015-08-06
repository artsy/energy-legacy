#import "ARSlugResolver.h"


@interface ARSlugResolver ()
@property (readwrite, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end


@implementation ARSlugResolver

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) return nil;

    _managedObjectContext = context;

    return self;
}

- (void)resolveAllSlugs
{
    [self resolveSlugsForShows];
    [self resolveSlugsForAlbums];
    [self resolveSlugsForLocations];
}

// We cannot use the default accessors for the classes because
// they have predicates on artwork count, and the defaults system

- (NSArray *)allObjectsOfClass:(NSString *)klass
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [NSEntityDescription entityForName:klass inManagedObjectContext:self.managedObjectContext];

    return [self.managedObjectContext executeFetchRequest:req error:nil];
}

- (void)resolveSlugsForAlbums
{
    NSArray *allAlbums = [self allObjectsOfClass:NSStringFromClass(Album.class)];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"editable = NO AND slug != 'all_artworks' AND slug != 'for_sale_works'"];
    NSArray *downloadedAlbums = [allAlbums filteredArrayUsingPredicate:predicate];
    [self mapSlugsToArtworksForArtworkContainerArray:downloadedAlbums];

    NSPredicate *allNonMagicAlbums = [NSPredicate predicateWithFormat:@"slug != 'all_artworks' AND slug != 'for_sale_works'"];
    NSArray *allUserAlbums = [allAlbums filteredArrayUsingPredicate:allNonMagicAlbums];
    [allUserAlbums makeObjectsPerformSelector:@selector(updateArtists)];

    Album *allArtworksAlbum = [Album createOrFindAlbumInContext:self.managedObjectContext slug:@"all_artworks"];
    allArtworksAlbum.name = NSLocalizedString(@"All Artworks", @"All Artworks Album title");
    allArtworksAlbum.artworks = [NSSet setWithArray:[Artwork findAllInContext:self.managedObjectContext]];
    allArtworksAlbum.editable = @(NO);

    if ([[Partner currentPartnerInContext:self.managedObjectContext] hasForSaleWorks]) {
        Album *forSaleWorksAlbum = [Album createOrFindAlbumInContext:self.managedObjectContext slug:@"for_sale_works"];
        forSaleWorksAlbum.name = NSLocalizedString(@"For Sale Works", @"For Sale Works Album Title");
        forSaleWorksAlbum.editable = @(NO);

        NSPredicate *forSaleWorks = [NSPredicate predicateWithFormat:@"isAvailableForSale = YES"];
        forSaleWorksAlbum.artworks = [NSSet setWithArray:[Artwork findAllWithPredicate:forSaleWorks inContext:self.managedObjectContext]];
    }
}

- (void)resolveSlugsForShows
{
    NSArray *allShows = [self allObjectsOfClass:NSStringFromClass(Show.class)];
    [self mapSlugsToArtworksForArtworkContainerArray:allShows];
    [allShows makeObjectsPerformSelector:@selector(updateArtists)];
}

- (void)resolveSlugsForLocations
{
    NSArray *allLocations = [self allObjectsOfClass:NSStringFromClass(Location.class)];
    [self mapSlugsToArtworksForArtworkContainerArray:allLocations];
}

- (void)mapSlugsToArtworksForArtworkContainerArray:(NSArray *)objects
{
    [objects each:^(id container) {

        NSMutableSet *artworks = [NSMutableSet set];

        [[container artworkSlugs] each:^(NSString *slug) {
            Artwork *artwork = [[Artwork findByAttribute:@"slug" withValue:slug inContext:self.managedObjectContext] firstObject];
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

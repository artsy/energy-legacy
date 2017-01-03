#if __has_include(<CoreSpotlight/CoreSpotlight.h>)

#import "ARSpotlightExporter.h"
#import "NSFetchRequest+ARModels.h"


@interface ARSpotlightExporter ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) CSSearchableIndex *index;
@end


@implementation ARSpotlightExporter

- (instancetype)initWithIndex:(CSSearchableIndex *)index
{
    self = [super init];
    if (!self) return nil;

    _index = index;

    return self;
}

- (void)syncDidFinish:(ARSync *)sync
{
    // TODO: Move to DI
    self.context = sync.config.managedObjectContext;
    [self updateCache];
}

- (void)updateCache
{
    [self.context save:nil];
    [self emptyLocalSpotlightCacheCompletion:^(NSError *__nullable error) {
        if (error) {
            ARErrorLog(@"Error deleting Spotlight Cache: %@", error);
            return;
        }

        ar_dispatch_async(^{
            NSArray *allArtworks = [self artworkResults];
            NSArray *allSpotlightData = [[self artistResults] arrayByAddingObjectsFromArray:allArtworks];

            [self addResultsToCache:allSpotlightData completion:^(NSError *__nullable error) {
                ARAppLifecycleLog(@"Updated Spotlight Store");
            }];
        });
    }];
}

- (void)emptyLocalSpotlightCacheCompletion:(void (^__nullable)(NSError *__nullable error))completionHandler
{
    [self.index deleteAllSearchableItemsWithCompletionHandler:completionHandler];
}

- (void)addResultsToCache:(NSArray *)results completion:(void (^__nullable)(NSError *__nullable error))completionHandler
{
    [self.index indexSearchableItems:results completionHandler:completionHandler];
}

- (NSArray *)artworkResults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSFetchRequest *allArtists = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:nil inContext:self.context defaults:defaults];

    NSArray *artworks = [self.context executeFetchRequest:allArtists error:nil];

    return [artworks map:^id(Artwork *artwork) {
        return [self itemForArtwork:artwork];
    }];
}

- (CSSearchableItem *)itemForArtwork:(Artwork *)artwork
{
    CSSearchableItemAttributeSet *artworkAttributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];

    artworkAttributes.title = artwork.gridTitle;
    artworkAttributes.contentDescription = artwork.medium ?: artwork.dimensions ?: @"";

    artworkAttributes.keywords = @[ artwork.medium ?: @"", artwork.inventoryID ?: @"" ];

    NSString *imagePath = [artwork gridThumbnailPath:ARFeedImageSizeMediumKey];
    if (imagePath && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        NSURL *localThumbnailURL = [NSURL fileURLWithPath:imagePath];
        if (localThumbnailURL) artworkAttributes.thumbnailURL = localThumbnailURL;
    }

    return [[CSSearchableItem alloc] initWithUniqueIdentifier:artwork.slug domainIdentifier:@"net.artsy.arwork" attributeSet:artworkAttributes];
}

- (NSArray<CSSearchableItem *> *)artistResults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSFetchRequest *allArtists = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Artist.class inContext:self.context defaults:defaults];

    NSArray *artists = [self.context executeFetchRequest:allArtists error:nil];

    return [artists map:^id(Artist *artist) {
        return [self itemForArtist:artist];
    }];
}

- (CSSearchableItem *)itemForArtist:(Artist *)artist
{
    CSSearchableItemAttributeSet *artistAttributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];

    artistAttributes.title = artist.gridTitle;
    artistAttributes.contentDescription = artist.blurb ?: artist.biography ?: @"";

    NSString *imagePath = [artist gridThumbnailPath:ARFeedImageSizeMediumKey];
    if (imagePath && [[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        NSURL *localThumbnailURL = [NSURL fileURLWithPath:imagePath];
        if (localThumbnailURL) artistAttributes.thumbnailURL = localThumbnailURL;
    }

    return [[CSSearchableItem alloc] initWithUniqueIdentifier:artist.slug domainIdentifier:@"net.artsy.artist" attributeSet:artistAttributes];
}

@end

#endif

#import "Location.h"
#import "NSDictionary+ObjectForKey.h"
#import "NSFetchRequest+ARModels.h"
#import "ARArtworkContainerCoverDataSource.h"
#import "ARSortDefinition.h"
#import "ARSortCache.h"
#import "ARSortOrderHost.h"


@interface Location ()
@property (nonatomic, strong, readonly) ARArtworkContainerCoverDataSource *coverDataSource;
@end


@implementation Location
@synthesize artworkSlugs, coverDataSource = _coverDataSource;

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    _coverDataSource = [[ARArtworkContainerCoverDataSource alloc] init];

    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.address = [dictionary objectForKeyNotNull:ARFeedAddressKey];
    self.addressSecond = [dictionary objectForKeyNotNull:ARFeedAddress2Key];
    self.city = [dictionary objectForKeyNotNull:ARFeedCityKey];
    self.phone = [dictionary objectForKeyNotNull:ARFeedPhoneKey];
    self.state = [dictionary objectForKeyNotNull:ARFeedStateKey];
    self.postalCode = [dictionary objectForKeyNotNull:ARFeedPostalCodeKey];
    self.name = [dictionary objectForKeyNotNull:ARFeedNameKey];
}

+ (NSFetchRequest *)allLocationsFetchRequestInContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults
{
    NSFetchRequest *req = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Location.class inContext:context defaults:defaults];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"address" ascending:YES] ];
    return req;
}

- (NSFetchRequest *)sortedArtworksFetchRequest
{
    ARArtworkSortOrder order = [ARSortCache sortOrderForObjectWithSlug:self.slug];
    if (order == ARArtworksSortOrderNotFound) {
        order = ARArtworksSortOrderDefault;
    }
    return [self artworksFetchRequestSortedBy:order];
}

- (NSFetchRequest *)artworksFetchRequestSortedBy:(ARArtworkSortOrder)order
{
    NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"ANY locations == %@", self];
    NSFetchRequest *req = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:self.managedObjectContext defaults:NSUserDefaults.standardUserDefaults];
    req.sortDescriptors = [ARSortOrderHost sortDescriptorstWithOrder:order];
    return req;
}

- (Artwork *)firstArtwork
{
    NSFetchRequest *fetch = [self sortedArtworksFetchRequest];
    [fetch setFetchLimit:1];
    return [[self.managedObjectContext executeFetchRequest:fetch error:nil] firstObject];
}

- (NSArray *)availableSorts
{
    return [ARSortOrderHost defaultSorts];
}

- (NSUInteger)collectionSize
{
    return self.artworks.count;
}

- (NSString *)gridTitle
{
    return self.name ?: self.address;
}

- (NSString *)gridSubtitle
{
    return self.name ? self.address : self.addressSecond;
}

- (NSString *)gridThumbnailPath:(NSString *)size
{
    return [self.coverDataSource gridThumbnailPath:size container:self];
}

- (NSURL *)gridThumbnailURL:(NSString *)size
{
    return [self.coverDataSource gridThumbnailURL:size container:self];
}

- (float)aspectRatio
{
    return [self.coverDataSource aspectRatioForContainer:self];
}

@end

#import "ARFeedTranslator.h"
#import "NSDictionary+ObjectForKey.h"
#import "ARSortCache.h"
#import "NSFetchRequest+ARModels.h"
#import "ARSortOrderHost.h"


@implementation Artist

- (NSString *)description
{
    return [NSString stringWithFormat:@"Artist : %@ ( %@ artworks %@ docs )", self.name, @(self.artworks.count), @(self.documents.count)];
}

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY"];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)aDictionary
{
    self.name = [aDictionary onlyStringForKey:ARFeedNameKey];
    self.years = [aDictionary onlyStringForKey:ARFeedYearsKey];

    self.displayName = [aDictionary onlyStringForKey:ARFeedDisplayNameKey];
    self.firstName = [aDictionary onlyStringForKey:ARFeedFirstNameKey];
    self.lastName = [aDictionary onlyStringForKey:ARFeedLastNameKey];
    self.middleName = [aDictionary onlyStringForKey:ARFeedMiddleNameKey];
    self.orderingKey = [aDictionary onlyStringForKey:ARFeedSortableIDKey];

    self.awards = [aDictionary onlyStringForKey:ARFeedAwardsKey];
    self.biography = [aDictionary onlyStringForKey:ARFeedBiographyKey];
    self.blurb = [aDictionary onlyStringForKey:ARFeedBlurbKey];
    self.hometown = [aDictionary onlyStringForKey:ARFeedHometownKey];
    self.nationality = [aDictionary onlyStringForKey:ARFeedNationalityKey];
    self.statement = [aDictionary onlyStringForKey:ARFeedStatementKey];

    NSString *imageSource = [aDictionary onlyStringForKey:ARFeedImageSourceKey];
    if (imageSource) {
        NSURL *imageURL = [[NSURL alloc] initWithString:imageSource];
        self.thumbnailBaseURL = [[imageURL URLByDeletingLastPathComponent] absoluteString];
    }

    if ([self.displayName isEqualToString:@""] || self.displayName == nil) {
        self.displayName = nil;

        if (!self.orderingKey) {
            self.orderingKey = self.lastName.lowercaseString;
        }
    }

    NSString *dateObject = [aDictionary onlyStringForKey:ARFeedDeathDateKey];
    if (dateObject) {
        NSDate *date = [dateFormatter dateFromString:dateObject];
        self.deathDate = date;
    }

    NSArray *artworksDicts = [aDictionary onlyArrayForKey:ARFeedArtworksKey];
    if (artworksDicts) {
        NSArray *artworks = [ARFeedTranslator addOrUpdateObjects:artworksDicts
                                                  withEntityName:@"Artwork"
                                                       inContext:self.managedObjectContext
                                                          saving:NO];
        NSSet *artworksSet = [NSSet setWithArray:artworks];
        [self addArtworks:artworksSet];
    }
}

- (NSFetchRequest *)artworksFetchRequestSortedBy:(ARArtworkSortOrder)order
{
    //    NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SUBQUERY(artists, $artist, $artist.slug == %@) .@count > 0", self.slug];
    NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"ANY artists.slug == %@", self.slug];
    NSFetchRequest *allArtworksRequest = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:self.managedObjectContext defaults:NSUserDefaults.standardUserDefaults];

    allArtworksRequest.sortDescriptors = [ARSortOrderHost sortDescriptorsWithoutArtistWithOrder:order];
    return allArtworksRequest;
}

- (NSArray *)availableSorts
{
    return [ARSortOrderHost defaultSortsWithoutArtist];
}

- (NSFetchRequest *)sortedArtworksFetchRequest
{
    ARArtworkSortOrder order = [ARSortCache sortOrderForObjectWithSlug:self.slug];
    if (order == ARArtworksSortOrderNotFound) {
        order = ARArtworksSortOrderDefault;
    }
    return [self artworksFetchRequestSortedBy:order];
}

// TODO: Why are these methods so similar? #644

- (NSString *)searchDisplayName
{
    if (self.displayName) {
        return self.displayName;
    }
    if (self.lastName && self.middleName && self.firstName) {
        return [NSString stringWithFormat:@"%@, %@ %@", self.lastName, self.firstName, self.middleName];
    }
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName];
    }
    if (self.name) {
        return self.name;
    }
    return @"Unknown Artist";
}

- (NSString *)presentableName
{
    if (self.displayName) {
        return self.displayName;
    }
    if (self.lastName && self.middleName && self.firstName) {
        return [NSString stringWithFormat:@"%@ %@ %@", self.firstName, self.middleName, self.lastName];
    }
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    }
    if (self.name) {
        return self.name;
    }
    return @"Unknown Artist";
}

- (Image *)gridThumbnailImage
{
    if (self.cover) return self.cover;
    return [[self firstArtwork] mainImage];
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
    return [[self gridThumbnailImage] imagePathWithFormatName:size];
}

- (NSURL *)gridThumbnailURL:(NSString *)size
{
    return [[self gridThumbnailImage] imageURLWithFormatName:size];
}

- (Artwork *)firstArtwork
{
    NSFetchRequest *fetch = [self sortedArtworksFetchRequest];
    [fetch setFetchLimit:1];
    NSArray *fetched = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    if (fetched.count < 1) {
        return nil;
    }
    return [fetched objectAtIndex:0];
}

- (NSString *)gridTitle
{
    return [self name];
}

- (NSString *)gridSubtitle
{
    NSUInteger artworksCount = self.collectionSize;
    NSString *suffix = artworksCount > 1 ? @"s" : @"";
    return [[NSString alloc] initWithFormat:@"%@ artwork%@", @(artworksCount), suffix];
}

- (NSUInteger)collectionSize
{
    return [self.managedObjectContext countForFetchRequest:[self sortedArtworksFetchRequest] error:nil];
}

- (BOOL)hasDocuments
{
    return self.documents.count > 0;
}

- (NSFetchRequest *)sortedDocumentsFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [Document entityDescriptionInContext:context];

    req.predicate = [NSPredicate predicateWithFormat:@"artist == %@", self];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES] ];
    return req;
}

- (NSArray *)sortedDocuments
{
    NSFetchRequest *request = [self sortedDocumentsFetchRequestInContext:self.managedObjectContext];
    return [self.managedObjectContext executeFetchRequest:request error:nil];
}

+ (NSFetchRequest *)allArtistsFetchRequestInContext:(NSManagedObjectContext *)context
{
    return [self allArtistsFetchRequestInContext:context defaults:NSUserDefaults.standardUserDefaults];
}

+ (NSFetchRequest *)allArtistsFetchRequestInContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults
{
    return [NSFetchRequest ar_allInstancesOfArtworkContainerClass:self inContext:context defaults:defaults];
}

- (NSFetchRequest *)showsFeaturingArtistFetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Show" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY artists == %@", self];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"endsAt" ascending:NO] ];
    return request;
}

- (NSFetchRequest *)albumsFeaturingArtistFetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Album" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY artists == %@", self];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    return request;
}

+ (Artist *)findOrCreateUnknownArtistInContext:(NSManagedObjectContext *)context
{
    Artist *unknownArtist = [Artist findFirstByAttribute:@"slug" withValue:@"unknown-artist" inContext:context];
    if (!unknownArtist) {
        unknownArtist = [Artist createInContext:context];
        unknownArtist.displayName = @"Unknown Artist";
        unknownArtist.slug = @"unknown-artist";
        unknownArtist.orderingKey = @"Unknown Artist";
        unknownArtist.name = @"Unknown Artist";
    }
    return unknownArtist;
}

@end

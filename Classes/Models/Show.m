#import "NSDictionary+ObjectForKey.h"
#import "ARSortDefinition.h"
#import "ARSortCache.h"
#import "NSFetchRequest+ARModels.h"
#import "InstallShotImage.h"
#import "ARSortOrderHost.h"
#import "ARArtworkContainerCoverDataSource.h"

static NSArray *sorts;


@interface Show ()
@property (nonatomic, strong, readonly) ARArtworkContainerCoverDataSource *coverDataSource;
@end


@implementation Show

@synthesize artworkSlugs, coverDataSource = _coverDataSource;

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    _coverDataSource = [[ARArtworkContainerCoverDataSource alloc] init];

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Show : %@ ( %@ artworks %@ docs )", self.name, @(self.artworks.count), @(self.documents.count)];
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.slug = [self.class folioSlug:dictionary];
    self.showSlug = [dictionary onlyStringForKey:ARFeedIDKey];

    self.name = [dictionary onlyStringForKey:ARFeedNameKey];
    self.status = [dictionary onlyStringForKey:ARFeedStatusKey];

    self.endsAt = [dictionary onlyDateFromStringForKey:ARFeedEndAtKey];
    self.startsAt = [dictionary onlyDateFromStringForKey:ARFeedStartAtKey];
    self.availabilityPeriod = [self generateAusstellungsdauer];
}

- (void)updateArtists
{
    self.artists = nil;
    for (Artwork *artwork in self.artworks) {
        [self addArtistsObject:artwork.artist];
    }
    [self updateName];
}

- (void)updateName
{
    // some shows don't have names to prevent duplication on the front page
    if (!self.name || [self.name isEqualToString:@""]) {
        NSMutableArray *names = [[NSMutableArray alloc] init];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"presentableName" ascending:YES];
        for (Artist *artist in [self.artists sortedArrayUsingDescriptors:@[ sort ]]) {
            [names addObject:artist.presentableName];
        }
        self.name = [names componentsJoinedByString:@", "];
    }
}

+ (NSString *)folioSlug:(NSDictionary *)dictionary
{
    NSString *partnerSlug = dictionary[@"partner"][@"id"];
    return [NSString stringWithFormat:@"%@-%@", partnerSlug, [dictionary onlyStringForKey:ARFeedIDKey]];
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

- (Artwork *)firstArtwork
{
    NSFetchRequest *fetch = [self sortedArtworksFetchRequest];
    [fetch setFetchLimit:1];
    return [[self.managedObjectContext executeFetchRequest:fetch error:nil] firstObject];
}

- (NSFetchRequest *)sortedDocumentsFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [Document entityInManagedObjectContext:context];
    req.predicate = [NSPredicate predicateWithFormat:@"show == %@ AND hasFile == YES", self];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES] ];
    return req;
}

- (NSArray *)sortedDocuments
{
    return [self.managedObjectContext executeFetchRequest:[self sortedDocumentsFetchRequestInContext:self.managedObjectContext] error:nil];
}

- (NSFetchRequest *)artworksFetchRequestSortedBy:(ARArtworkSortOrder)order
{
    NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"ANY shows == %@", self];

    NSFetchRequest *req = [NSFetchRequest ar_allArtworksOfArtworkContainerWithSelfPredicate:scopePredicate inContext:self.managedObjectContext defaults:NSUserDefaults.standardUserDefaults];
    req.sortDescriptors = [ARSortOrderHost sortDescriptorstWithOrder:order];
    return req;
}

- (NSArray *)availableSorts
{
    // We don't want artist sorts when we only have 1 artist.
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

- (NSString *)gridTitle
{
    return [self presentableName];
}

- (NSString *)presentableName
{
    if (self.name) {
        // check if this is a fair booth title; if so, remove the partner's name from the title
        NSString *fairBoothTitlePrefix = [NSString stringWithFormat:@"%@ at ", [Partner currentPartnerInContext:self.managedObjectContext].name];
        return [self.name stringByReplacingOccurrencesOfString:fairBoothTitlePrefix withString:@""];
    }
    return @"Unnamed Show";
}

- (NSUInteger)collectionSize
{
    return [self.managedObjectContext countForFetchRequest:[self sortedArtworksFetchRequest] error:nil];
}

- (NSString *)gridSubtitle
{
    return self.availabilityPeriod;
}

- (NSString *)generateAusstellungsdauer
{
    if (!self.startsAt && !self.endsAt) return @"";

    // This function will return a string that shows the time that the show is/was open, e.g.  "July 2 - 12, 2011"
    // If you can figure a better name for the function, I'd love to hear it, no-one could come up with it on #irtsy

    // it turned out the word did exist in German. Thanks Leonard / Jessica ./

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit desiredComponents = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    NSDateComponents *startsComponents = [gregorian components:desiredComponents fromDate:self.startsAt];
    NSDateComponents *endsComponents = [gregorian components:desiredComponents fromDate:self.endsAt];

    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMM"];


    // Same month - "July 2 - 12, 2011"
    if (endsComponents.month == startsComponents.month) {
        return [NSString stringWithFormat:@"%@ %@ - %@, %@", [monthFormatter stringFromDate:self.startsAt], @(startsComponents.day), @(endsComponents.day), @(endsComponents.year)];
    }

    // Same year - "June 12 - August 20, 2012"
    if (endsComponents.year == startsComponents.year) {
        return [NSString stringWithFormat:@"%@ %@ - %@ %@, %@", [monthFormatter stringFromDate:self.startsAt], @(startsComponents.day), [monthFormatter stringFromDate:self.endsAt], @(endsComponents.day), @(endsComponents.year)];
    }

    // Different year - "January 12, 2011 - April 19, 2014"
    return [NSString stringWithFormat:@"%@ %@, %@ - %@ %@, %@", [monthFormatter stringFromDate:self.startsAt], @(startsComponents.day), @(startsComponents.year), [monthFormatter stringFromDate:self.endsAt], @(endsComponents.day), @(endsComponents.year)];
}

+ (NSFetchRequest *)allShowsFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [NSFetchRequest ar_allInstancesOfArtworkContainerClass:Show.class inContext:context defaults:[NSUserDefaults standardUserDefaults]];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    return req;
}

+ (NSArray *)sortDescriptorsForDates
{
    return @[
        [NSSortDescriptor sortDescriptorWithKey:@"startsAt" ascending:NO],
        [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]
    ];
}

- (NSFetchRequest *)installationShotsFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [InstallShotImage entityDescriptionInContext:context];
    req.predicate = [NSPredicate predicateWithFormat:@"showWithImageInInstallation == %@", self];
    req.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES] ];
    return req;
}


@end

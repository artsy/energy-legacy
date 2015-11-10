#import "NSDictionary+ObjectForKey.h"
#import "PartnerOption.h"
#import "SubscriptionPlan.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>


@implementation Partner

+ (NSString *)currentPartnerID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:ARPartnerID];
}

- (void)updateWithDictionary:(NSDictionary *)dict
{
    self.name = [dict onlyStringForKey:ARFeedNameKey];
    self.website = [dict onlyStringForKey:ARFeedWebsiteKey];
    self.email = [dict onlyStringForKey:ARFeedEmailKey];
    self.partnerType = [dict onlyStringForKey:ARFeedTypeKey];

    self.artworksCount = [dict onlyNumberForKey:ARFeedArtworksCountKey];
    self.artistDocumentsCount = [dict onlyNumberForKey:ARFeedArtistDocumentsCountKey];
    self.showDocumentsCount = [dict onlyNumberForKey:ARFeedShowDocumentsCountKey];
    self.artistsCount = [dict onlyNumberForKey:ARFeedArtistsCountKey];
    self.subscriptionState = [dict onlyStringForKey:ARFeedPartnerSubscriptionStateKey];
    self.region = [dict onlyStringForKey:ARFeedRegionKey];
    self.partnerLimitedAccess = [dict onlyNumberForKey:ARFeedHasLimitedPartnerToolAccessKey];
    self.relativeSize = [dict onlyStringForKey:ARFeedRelativeSizeKey];
    self.contractType = [dict onlyStringForKey:ARFeedPartnerContractTypeKey];
    self.hasFullProfile = [dict onlyNumberForKey:ARFeedHasFullProfileKey];
    self.hasDefaultProfile = [dict onlyNumberForKey:ARFeedHasDefaultProfileIDKey];
    self.defaultProfileID = [dict onlyStringForKey:ARFeedDefaultProfilePublicKey];
    self.partnerID = [dict onlyStringForKey:ARFeedPartnerRawIDKey];
    self.foundingPartner = [dict onlyNumberForKey:ARFeedPartnerIsFoundingPartnerKey];

    NSDictionary *admin = [dict objectForKeyNotNull:ARFeedPartnerAdminKey];
    self.admin = [User addOrUpdateWithDictionary:admin inContext:self.managedObjectContext saving:NO];

    NSDictionary *partnerOptions = [dict onlyDictionaryForKey:ARFeedPartnerFlagsKey];
    self.flags = [PartnerOption optionsWithDictionary:partnerOptions inContext:self.managedObjectContext];

    NSArray *subscriptionPlans = [dict onlyArrayForKey:ARFeedPartnerSubscriptionPlansNameKey];
    self.subscriptionPlans = [SubscriptionPlan plansWithStringArray:subscriptionPlans inContext:self.managedObjectContext];
}

- (BOOL)hasUploadedWorks
{
    return self.artworksCount.boolValue || [Artwork countInContext:self.managedObjectContext error:nil];
}

- (BOOL)hasPublishedWorks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPublished = YES"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasWorksWithPrice
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayPrice != '' OR backendPrice != ''"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasForSaleWorks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAvailableForSale = YES"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasSoldWorks
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"availability = 'sold'"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasConfidentialNotes
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"confidentialNotes != ''"];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

- (BOOL)hasSoldWorksWithPrices
{
    NSPredicate *hasPricesPredicate = [NSPredicate predicateWithFormat:@"displayPrice != '' OR backendPrice != ''"];
    NSPredicate *hasSoldWorksPredicate = [NSPredicate predicateWithFormat:@"availability = 'sold'"];

    NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ hasPricesPredicate, hasSoldWorksPredicate ]];
    return ([Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext] != nil);
}

+ (Partner *)currentPartner
{
    return [Partner findFirst];
}

+ (Partner *)currentPartnerInContext:(NSManagedObjectContext *)context
{
    return [Partner findFirstInContext:context];
}

- (NSDate *)lastCMSLoginDate
{
    PartnerOption *login = [self.flags select:^BOOL(PartnerOption *object) {
        return ([object.key  isEqual: @"last_cms_access"]);
    }].firstObject;

    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    return [dateFormatter dateFromString:login.value];
}

- (ARPartnerType)type
{
    return [self.partnerType isEqualToString:@"Private Collector"] ? ARPartnerTypeCollector : ARPartnerTypeGallery;
}


@end

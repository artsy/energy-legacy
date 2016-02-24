// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Partner.m instead.

#import "_Partner.h"

const struct PartnerAttributes PartnerAttributes = {
    .active = @"active",
    .artistDocumentsCount = @"artistDocumentsCount",
    .artistsCount = @"artistsCount",
    .artworksCount = @"artworksCount",
    .contractType = @"contractType",
    .createdAt = @"createdAt",
    .defaultProfileID = @"defaultProfileID",
    .defaultProfilePublic = @"defaultProfilePublic",
    .directlyContactable = @"directlyContactable",
    .email = @"email",
    .foundingPartner = @"foundingPartner",
    .hasDefaultProfile = @"hasDefaultProfile",
    .hasFullProfile = @"hasFullProfile",
    .name = @"name",
    .partnerID = @"partnerID",
    .partnerLimitedAccess = @"partnerLimitedAccess",
    .partnerType = @"partnerType",
    .region = @"region",
    .representativeEmail = @"representativeEmail",
    .showDocumentsCount = @"showDocumentsCount",
    .size = @"size",
    .slug = @"slug",
    .subscriptionState = @"subscriptionState",
    .updatedAt = @"updatedAt",
    .website = @"website",
};

const struct PartnerRelationships PartnerRelationships = {
    .admin = @"admin",
    .artworks = @"artworks",
    .flags = @"flags",
    .subscriptionPlans = @"subscriptionPlans",
};

const struct PartnerUserInfo PartnerUserInfo = {};


@implementation PartnerID
@end


@implementation _Partner

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Partner" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Partner";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Partner" inManagedObjectContext:moc_];
}

- (PartnerID *)objectID
{
    return (PartnerID *)[super objectID];
}


@dynamic active;
@dynamic artistDocumentsCount;
@dynamic artistsCount;
@dynamic artworksCount;
@dynamic contractType;
@dynamic createdAt;
@dynamic defaultProfileID;
@dynamic defaultProfilePublic;
@dynamic directlyContactable;
@dynamic email;
@dynamic foundingPartner;
@dynamic hasDefaultProfile;
@dynamic hasFullProfile;
@dynamic name;
@dynamic partnerID;
@dynamic partnerLimitedAccess;
@dynamic partnerType;
@dynamic region;
@dynamic representativeEmail;
@dynamic showDocumentsCount;
@dynamic size;
@dynamic slug;
@dynamic subscriptionState;
@dynamic updatedAt;
@dynamic website;


@dynamic admin;
@dynamic artworks;
- (NSMutableSet *)artworksSet
{
    [self willAccessValueForKey:@"artworks"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"artworks"];
    [self didAccessValueForKey:@"artworks"];
    return result;
}

@dynamic flags;
- (NSMutableSet *)flagsSet
{
    [self willAccessValueForKey:@"flags"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"flags"];
    [self didAccessValueForKey:@"flags"];
    return result;
}

@dynamic subscriptionPlans;
- (NSMutableSet *)subscriptionPlansSet
{
    [self willAccessValueForKey:@"subscriptionPlans"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"subscriptionPlans"];
    [self didAccessValueForKey:@"subscriptionPlans"];
    return result;
}


@end

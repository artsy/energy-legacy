// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Partner.m instead.

#import "_Partner.h"


@implementation PartnerID
@end


@implementation _Partner

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"activeValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"active"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"artistDocumentsCountValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"artistDocumentsCount"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"artistsCountValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"artistsCount"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"artworksCountValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"artworksCount"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"defaultProfilePublicValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"defaultProfilePublic"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"directlyContactableValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"directlyContactable"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"foundingPartnerValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"foundingPartner"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"hasDefaultProfileValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"hasDefaultProfile"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"hasFullProfileValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"hasFullProfile"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"limitedFolioAccessValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"limitedFolioAccess"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"partnerLimitedAccessValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"partnerLimitedAccess"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"showDocumentsCountValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"showDocumentsCount"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"sizeValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"size"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic active;

- (BOOL)activeValue
{
    NSNumber *result = [self active];
    return [result boolValue];
}

- (void)setActiveValue:(BOOL)value_
{
    [self setActive:@(value_)];
}

- (BOOL)primitiveActiveValue
{
    NSNumber *result = [self primitiveActive];
    return [result boolValue];
}

- (void)setPrimitiveActiveValue:(BOOL)value_
{
    [self setPrimitiveActive:@(value_)];
}

@dynamic artistDocumentsCount;

- (int32_t)artistDocumentsCountValue
{
    NSNumber *result = [self artistDocumentsCount];
    return [result intValue];
}

- (void)setArtistDocumentsCountValue:(int32_t)value_
{
    [self setArtistDocumentsCount:@(value_)];
}

- (int32_t)primitiveArtistDocumentsCountValue
{
    NSNumber *result = [self primitiveArtistDocumentsCount];
    return [result intValue];
}

- (void)setPrimitiveArtistDocumentsCountValue:(int32_t)value_
{
    [self setPrimitiveArtistDocumentsCount:@(value_)];
}

@dynamic artistsCount;

- (int32_t)artistsCountValue
{
    NSNumber *result = [self artistsCount];
    return [result intValue];
}

- (void)setArtistsCountValue:(int32_t)value_
{
    [self setArtistsCount:@(value_)];
}

- (int32_t)primitiveArtistsCountValue
{
    NSNumber *result = [self primitiveArtistsCount];
    return [result intValue];
}

- (void)setPrimitiveArtistsCountValue:(int32_t)value_
{
    [self setPrimitiveArtistsCount:@(value_)];
}

@dynamic artworksCount;

- (int32_t)artworksCountValue
{
    NSNumber *result = [self artworksCount];
    return [result intValue];
}

- (void)setArtworksCountValue:(int32_t)value_
{
    [self setArtworksCount:@(value_)];
}

- (int32_t)primitiveArtworksCountValue
{
    NSNumber *result = [self primitiveArtworksCount];
    return [result intValue];
}

- (void)setPrimitiveArtworksCountValue:(int32_t)value_
{
    [self setPrimitiveArtworksCount:@(value_)];
}

@dynamic contractType;

@dynamic createdAt;

@dynamic defaultProfileID;

@dynamic defaultProfilePublic;

- (BOOL)defaultProfilePublicValue
{
    NSNumber *result = [self defaultProfilePublic];
    return [result boolValue];
}

- (void)setDefaultProfilePublicValue:(BOOL)value_
{
    [self setDefaultProfilePublic:@(value_)];
}

- (BOOL)primitiveDefaultProfilePublicValue
{
    NSNumber *result = [self primitiveDefaultProfilePublic];
    return [result boolValue];
}

- (void)setPrimitiveDefaultProfilePublicValue:(BOOL)value_
{
    [self setPrimitiveDefaultProfilePublic:@(value_)];
}

@dynamic directlyContactable;

- (BOOL)directlyContactableValue
{
    NSNumber *result = [self directlyContactable];
    return [result boolValue];
}

- (void)setDirectlyContactableValue:(BOOL)value_
{
    [self setDirectlyContactable:@(value_)];
}

- (BOOL)primitiveDirectlyContactableValue
{
    NSNumber *result = [self primitiveDirectlyContactable];
    return [result boolValue];
}

- (void)setPrimitiveDirectlyContactableValue:(BOOL)value_
{
    [self setPrimitiveDirectlyContactable:@(value_)];
}

@dynamic email;

@dynamic foundingPartner;

- (BOOL)foundingPartnerValue
{
    NSNumber *result = [self foundingPartner];
    return [result boolValue];
}

- (void)setFoundingPartnerValue:(BOOL)value_
{
    [self setFoundingPartner:@(value_)];
}

- (BOOL)primitiveFoundingPartnerValue
{
    NSNumber *result = [self primitiveFoundingPartner];
    return [result boolValue];
}

- (void)setPrimitiveFoundingPartnerValue:(BOOL)value_
{
    [self setPrimitiveFoundingPartner:@(value_)];
}

@dynamic hasDefaultProfile;

- (BOOL)hasDefaultProfileValue
{
    NSNumber *result = [self hasDefaultProfile];
    return [result boolValue];
}

- (void)setHasDefaultProfileValue:(BOOL)value_
{
    [self setHasDefaultProfile:@(value_)];
}

- (BOOL)primitiveHasDefaultProfileValue
{
    NSNumber *result = [self primitiveHasDefaultProfile];
    return [result boolValue];
}

- (void)setPrimitiveHasDefaultProfileValue:(BOOL)value_
{
    [self setPrimitiveHasDefaultProfile:@(value_)];
}

@dynamic hasFullProfile;

- (BOOL)hasFullProfileValue
{
    NSNumber *result = [self hasFullProfile];
    return [result boolValue];
}

- (void)setHasFullProfileValue:(BOOL)value_
{
    [self setHasFullProfile:@(value_)];
}

- (BOOL)primitiveHasFullProfileValue
{
    NSNumber *result = [self primitiveHasFullProfile];
    return [result boolValue];
}

- (void)setPrimitiveHasFullProfileValue:(BOOL)value_
{
    [self setPrimitiveHasFullProfile:@(value_)];
}

@dynamic limitedFolioAccess;

- (BOOL)limitedFolioAccessValue
{
    NSNumber *result = [self limitedFolioAccess];
    return [result boolValue];
}

- (void)setLimitedFolioAccessValue:(BOOL)value_
{
    [self setLimitedFolioAccess:@(value_)];
}

- (BOOL)primitiveLimitedFolioAccessValue
{
    NSNumber *result = [self primitiveLimitedFolioAccess];
    return [result boolValue];
}

- (void)setPrimitiveLimitedFolioAccessValue:(BOOL)value_
{
    [self setPrimitiveLimitedFolioAccess:@(value_)];
}

@dynamic name;

@dynamic partnerID;

@dynamic partnerLimitedAccess;

- (BOOL)partnerLimitedAccessValue
{
    NSNumber *result = [self partnerLimitedAccess];
    return [result boolValue];
}

- (void)setPartnerLimitedAccessValue:(BOOL)value_
{
    [self setPartnerLimitedAccess:@(value_)];
}

- (BOOL)primitivePartnerLimitedAccessValue
{
    NSNumber *result = [self primitivePartnerLimitedAccess];
    return [result boolValue];
}

- (void)setPrimitivePartnerLimitedAccessValue:(BOOL)value_
{
    [self setPrimitivePartnerLimitedAccess:@(value_)];
}

@dynamic partnerType;

@dynamic region;

@dynamic representativeEmail;

@dynamic showDocumentsCount;

- (int32_t)showDocumentsCountValue
{
    NSNumber *result = [self showDocumentsCount];
    return [result intValue];
}

- (void)setShowDocumentsCountValue:(int32_t)value_
{
    [self setShowDocumentsCount:@(value_)];
}

- (int32_t)primitiveShowDocumentsCountValue
{
    NSNumber *result = [self primitiveShowDocumentsCount];
    return [result intValue];
}

- (void)setPrimitiveShowDocumentsCountValue:(int32_t)value_
{
    [self setPrimitiveShowDocumentsCount:@(value_)];
}

@dynamic size;

- (int16_t)sizeValue
{
    NSNumber *result = [self size];
    return [result shortValue];
}

- (void)setSizeValue:(int16_t)value_
{
    [self setSize:@(value_)];
}

- (int16_t)primitiveSizeValue
{
    NSNumber *result = [self primitiveSize];
    return [result shortValue];
}

- (void)setPrimitiveSizeValue:(int16_t)value_
{
    [self setPrimitiveSize:@(value_)];
}

@dynamic slug;

@dynamic subscriptionState;

@dynamic updatedAt;

@dynamic website;

@dynamic admin;

@dynamic artworks;

- (NSMutableSet<Artwork *> *)artworksSet
{
    [self willAccessValueForKey:@"artworks"];

    NSMutableSet<Artwork *> *result = (NSMutableSet<Artwork *> *)[self mutableSetValueForKey:@"artworks"];

    [self didAccessValueForKey:@"artworks"];
    return result;
}

@dynamic flags;

- (NSMutableSet<PartnerOption *> *)flagsSet
{
    [self willAccessValueForKey:@"flags"];

    NSMutableSet<PartnerOption *> *result = (NSMutableSet<PartnerOption *> *)[self mutableSetValueForKey:@"flags"];

    [self didAccessValueForKey:@"flags"];
    return result;
}

@dynamic subscriptionPlans;

- (NSMutableSet<SubscriptionPlan *> *)subscriptionPlansSet
{
    [self willAccessValueForKey:@"subscriptionPlans"];

    NSMutableSet<SubscriptionPlan *> *result = (NSMutableSet<SubscriptionPlan *> *)[self mutableSetValueForKey:@"subscriptionPlans"];

    [self didAccessValueForKey:@"subscriptionPlans"];
    return result;
}

@end


@implementation PartnerAttributes
+ (NSString *)active
{
    return @"active";
}
+ (NSString *)artistDocumentsCount
{
    return @"artistDocumentsCount";
}
+ (NSString *)artistsCount
{
    return @"artistsCount";
}
+ (NSString *)artworksCount
{
    return @"artworksCount";
}
+ (NSString *)contractType
{
    return @"contractType";
}
+ (NSString *)createdAt
{
    return @"createdAt";
}
+ (NSString *)defaultProfileID
{
    return @"defaultProfileID";
}
+ (NSString *)defaultProfilePublic
{
    return @"defaultProfilePublic";
}
+ (NSString *)directlyContactable
{
    return @"directlyContactable";
}
+ (NSString *)email
{
    return @"email";
}
+ (NSString *)foundingPartner
{
    return @"foundingPartner";
}
+ (NSString *)hasDefaultProfile
{
    return @"hasDefaultProfile";
}
+ (NSString *)hasFullProfile
{
    return @"hasFullProfile";
}
+ (NSString *)limitedFolioAccess
{
    return @"limitedFolioAccess";
}
+ (NSString *)name
{
    return @"name";
}
+ (NSString *)partnerID
{
    return @"partnerID";
}
+ (NSString *)partnerLimitedAccess
{
    return @"partnerLimitedAccess";
}
+ (NSString *)partnerType
{
    return @"partnerType";
}
+ (NSString *)region
{
    return @"region";
}
+ (NSString *)representativeEmail
{
    return @"representativeEmail";
}
+ (NSString *)showDocumentsCount
{
    return @"showDocumentsCount";
}
+ (NSString *)size
{
    return @"size";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)subscriptionState
{
    return @"subscriptionState";
}
+ (NSString *)updatedAt
{
    return @"updatedAt";
}
+ (NSString *)website
{
    return @"website";
}
@end


@implementation PartnerRelationships
+ (NSString *)admin
{
    return @"admin";
}
+ (NSString *)artworks
{
    return @"artworks";
}
+ (NSString *)flags
{
    return @"flags";
}
+ (NSString *)subscriptionPlans
{
    return @"subscriptionPlans";
}
@end

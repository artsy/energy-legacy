// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Partner.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "ARManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class User;
@class Artwork;
@class PartnerOption;
@class SubscriptionPlan;


@interface PartnerID : NSManagedObjectID
{
}
@end


@interface _Partner : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) PartnerID *objectID;

@property (nonatomic, strong, nullable) NSNumber *active;

@property (atomic) BOOL activeValue;
- (BOOL)activeValue;
- (void)setActiveValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber *artistDocumentsCount;

@property (atomic) int32_t artistDocumentsCountValue;
- (int32_t)artistDocumentsCountValue;
- (void)setArtistDocumentsCountValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber *artistsCount;

@property (atomic) int32_t artistsCountValue;
- (int32_t)artistsCountValue;
- (void)setArtistsCountValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber *artworksCount;

@property (atomic) int32_t artworksCountValue;
- (int32_t)artworksCountValue;
- (void)setArtworksCountValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString *contractType;

@property (nonatomic, strong, nullable) NSDate *createdAt;

@property (nonatomic, strong, nullable) NSString *defaultProfileID;

@property (nonatomic, strong, nullable) NSNumber *defaultProfilePublic;

@property (atomic) BOOL defaultProfilePublicValue;
- (BOOL)defaultProfilePublicValue;
- (void)setDefaultProfilePublicValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber *directlyContactable;

@property (atomic) BOOL directlyContactableValue;
- (BOOL)directlyContactableValue;
- (void)setDirectlyContactableValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString *email;

@property (nonatomic, strong, nullable) NSNumber *foundingPartner;

@property (atomic) BOOL foundingPartnerValue;
- (BOOL)foundingPartnerValue;
- (void)setFoundingPartnerValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber *hasDefaultProfile;

@property (atomic) BOOL hasDefaultProfileValue;
- (BOOL)hasDefaultProfileValue;
- (void)setHasDefaultProfileValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber *hasFullProfile;

@property (atomic) BOOL hasFullProfileValue;
- (BOOL)hasFullProfileValue;
- (void)setHasFullProfileValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString *name;

@property (nonatomic, strong, nullable) NSString *partnerID;

@property (nonatomic, strong, nullable) NSNumber *partnerLimitedAccess;

@property (atomic) BOOL partnerLimitedAccessValue;
- (BOOL)partnerLimitedAccessValue;
- (void)setPartnerLimitedAccessValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString *partnerType;

@property (nonatomic, strong, nullable) NSString *region;

@property (nonatomic, strong, nullable) NSString *representativeEmail;

@property (nonatomic, strong, nullable) NSNumber *showDocumentsCount;

@property (atomic) int32_t showDocumentsCountValue;
- (int32_t)showDocumentsCountValue;
- (void)setShowDocumentsCountValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber *size;

@property (atomic) int16_t sizeValue;
- (int16_t)sizeValue;
- (void)setSizeValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString *slug;

@property (nonatomic, strong, nullable) NSString *subscriptionState;

@property (nonatomic, strong, nullable) NSDate *updatedAt;

@property (nonatomic, strong, nullable) NSString *website;

@property (nonatomic, strong, nullable) User *admin;

@property (nonatomic, strong, nullable) NSSet<Artwork *> *artworks;
- (nullable NSMutableSet<Artwork *> *)artworksSet;

@property (nonatomic, strong, nullable) NSSet<PartnerOption *> *flags;
- (nullable NSMutableSet<PartnerOption *> *)flagsSet;

@property (nonatomic, strong, nullable) NSSet<SubscriptionPlan *> *subscriptionPlans;
- (nullable NSMutableSet<SubscriptionPlan *> *)subscriptionPlansSet;

@end


@interface _Partner (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet<Artwork *> *)value_;
- (void)removeArtworks:(NSSet<Artwork *> *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;

@end


@interface _Partner (FlagsCoreDataGeneratedAccessors)
- (void)addFlags:(NSSet<PartnerOption *> *)value_;
- (void)removeFlags:(NSSet<PartnerOption *> *)value_;
- (void)addFlagsObject:(PartnerOption *)value_;
- (void)removeFlagsObject:(PartnerOption *)value_;

@end


@interface _Partner (SubscriptionPlansCoreDataGeneratedAccessors)
- (void)addSubscriptionPlans:(NSSet<SubscriptionPlan *> *)value_;
- (void)removeSubscriptionPlans:(NSSet<SubscriptionPlan *> *)value_;
- (void)addSubscriptionPlansObject:(SubscriptionPlan *)value_;
- (void)removeSubscriptionPlansObject:(SubscriptionPlan *)value_;

@end


@interface _Partner (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveActive;
- (void)setPrimitiveActive:(NSNumber *)value;

- (BOOL)primitiveActiveValue;
- (void)setPrimitiveActiveValue:(BOOL)value_;

- (NSNumber *)primitiveArtistDocumentsCount;
- (void)setPrimitiveArtistDocumentsCount:(NSNumber *)value;

- (int32_t)primitiveArtistDocumentsCountValue;
- (void)setPrimitiveArtistDocumentsCountValue:(int32_t)value_;

- (NSNumber *)primitiveArtistsCount;
- (void)setPrimitiveArtistsCount:(NSNumber *)value;

- (int32_t)primitiveArtistsCountValue;
- (void)setPrimitiveArtistsCountValue:(int32_t)value_;

- (NSNumber *)primitiveArtworksCount;
- (void)setPrimitiveArtworksCount:(NSNumber *)value;

- (int32_t)primitiveArtworksCountValue;
- (void)setPrimitiveArtworksCountValue:(int32_t)value_;

- (NSString *)primitiveContractType;
- (void)setPrimitiveContractType:(NSString *)value;

- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;

- (NSString *)primitiveDefaultProfileID;
- (void)setPrimitiveDefaultProfileID:(NSString *)value;

- (NSNumber *)primitiveDefaultProfilePublic;
- (void)setPrimitiveDefaultProfilePublic:(NSNumber *)value;

- (BOOL)primitiveDefaultProfilePublicValue;
- (void)setPrimitiveDefaultProfilePublicValue:(BOOL)value_;

- (NSNumber *)primitiveDirectlyContactable;
- (void)setPrimitiveDirectlyContactable:(NSNumber *)value;

- (BOOL)primitiveDirectlyContactableValue;
- (void)setPrimitiveDirectlyContactableValue:(BOOL)value_;

- (NSString *)primitiveEmail;
- (void)setPrimitiveEmail:(NSString *)value;

- (NSNumber *)primitiveFoundingPartner;
- (void)setPrimitiveFoundingPartner:(NSNumber *)value;

- (BOOL)primitiveFoundingPartnerValue;
- (void)setPrimitiveFoundingPartnerValue:(BOOL)value_;

- (NSNumber *)primitiveHasDefaultProfile;
- (void)setPrimitiveHasDefaultProfile:(NSNumber *)value;

- (BOOL)primitiveHasDefaultProfileValue;
- (void)setPrimitiveHasDefaultProfileValue:(BOOL)value_;

- (NSNumber *)primitiveHasFullProfile;
- (void)setPrimitiveHasFullProfile:(NSNumber *)value;

- (BOOL)primitiveHasFullProfileValue;
- (void)setPrimitiveHasFullProfileValue:(BOOL)value_;

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

- (NSString *)primitivePartnerID;
- (void)setPrimitivePartnerID:(NSString *)value;

- (NSNumber *)primitivePartnerLimitedAccess;
- (void)setPrimitivePartnerLimitedAccess:(NSNumber *)value;

- (BOOL)primitivePartnerLimitedAccessValue;
- (void)setPrimitivePartnerLimitedAccessValue:(BOOL)value_;

- (NSString *)primitivePartnerType;
- (void)setPrimitivePartnerType:(NSString *)value;

- (NSString *)primitiveRegion;
- (void)setPrimitiveRegion:(NSString *)value;

- (NSString *)primitiveRepresentativeEmail;
- (void)setPrimitiveRepresentativeEmail:(NSString *)value;

- (NSNumber *)primitiveShowDocumentsCount;
- (void)setPrimitiveShowDocumentsCount:(NSNumber *)value;

- (int32_t)primitiveShowDocumentsCountValue;
- (void)setPrimitiveShowDocumentsCountValue:(int32_t)value_;

- (NSNumber *)primitiveSize;
- (void)setPrimitiveSize:(NSNumber *)value;

- (int16_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int16_t)value_;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (NSString *)primitiveSubscriptionState;
- (void)setPrimitiveSubscriptionState:(NSString *)value;

- (NSDate *)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate *)value;

- (NSString *)primitiveWebsite;
- (void)setPrimitiveWebsite:(NSString *)value;

- (User *)primitiveAdmin;
- (void)setPrimitiveAdmin:(User *)value;

- (NSMutableSet<Artwork *> *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet<Artwork *> *)value;

- (NSMutableSet<PartnerOption *> *)primitiveFlags;
- (void)setPrimitiveFlags:(NSMutableSet<PartnerOption *> *)value;

- (NSMutableSet<SubscriptionPlan *> *)primitiveSubscriptionPlans;
- (void)setPrimitiveSubscriptionPlans:(NSMutableSet<SubscriptionPlan *> *)value;

@end


@interface PartnerAttributes : NSObject
+ (NSString *)active;
+ (NSString *)artistDocumentsCount;
+ (NSString *)artistsCount;
+ (NSString *)artworksCount;
+ (NSString *)contractType;
+ (NSString *)createdAt;
+ (NSString *)defaultProfileID;
+ (NSString *)defaultProfilePublic;
+ (NSString *)directlyContactable;
+ (NSString *)email;
+ (NSString *)foundingPartner;
+ (NSString *)hasDefaultProfile;
+ (NSString *)hasFullProfile;
+ (NSString *)name;
+ (NSString *)partnerID;
+ (NSString *)partnerLimitedAccess;
+ (NSString *)partnerType;
+ (NSString *)region;
+ (NSString *)representativeEmail;
+ (NSString *)showDocumentsCount;
+ (NSString *)size;
+ (NSString *)slug;
+ (NSString *)subscriptionState;
+ (NSString *)updatedAt;
+ (NSString *)website;
@end


@interface PartnerRelationships : NSObject
+ (NSString *)admin;
+ (NSString *)artworks;
+ (NSString *)flags;
+ (NSString *)subscriptionPlans;
@end

NS_ASSUME_NONNULL_END

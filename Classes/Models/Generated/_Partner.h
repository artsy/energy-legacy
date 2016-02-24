// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Partner.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct PartnerAttributes {
    __unsafe_unretained NSString *active;
    __unsafe_unretained NSString *artistDocumentsCount;
    __unsafe_unretained NSString *artistsCount;
    __unsafe_unretained NSString *artworksCount;
    __unsafe_unretained NSString *contractType;
    __unsafe_unretained NSString *createdAt;
    __unsafe_unretained NSString *defaultProfileID;
    __unsafe_unretained NSString *defaultProfilePublic;
    __unsafe_unretained NSString *directlyContactable;
    __unsafe_unretained NSString *email;
    __unsafe_unretained NSString *foundingPartner;
    __unsafe_unretained NSString *hasDefaultProfile;
    __unsafe_unretained NSString *hasFullProfile;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *partnerID;
    __unsafe_unretained NSString *partnerLimitedAccess;
    __unsafe_unretained NSString *partnerType;
    __unsafe_unretained NSString *region;
    __unsafe_unretained NSString *representativeEmail;
    __unsafe_unretained NSString *showDocumentsCount;
    __unsafe_unretained NSString *size;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *subscriptionState;
    __unsafe_unretained NSString *updatedAt;
    __unsafe_unretained NSString *website;
} PartnerAttributes;

extern const struct PartnerRelationships {
    __unsafe_unretained NSString *admin;
    __unsafe_unretained NSString *artworks;
    __unsafe_unretained NSString *flags;
    __unsafe_unretained NSString *subscriptionPlans;
} PartnerRelationships;

extern const struct PartnerUserInfo {
} PartnerUserInfo;

@class User;
@class Artwork;
@class PartnerOption;
@class SubscriptionPlan;


@interface PartnerID : ARManagedObjectID {
}
@end


@interface _Partner : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (PartnerID *)objectID;

@property (nonatomic, strong) NSNumber *active;
@property (nonatomic, strong) NSNumber *artistDocumentsCount;
@property (nonatomic, strong) NSNumber *artistsCount;
@property (nonatomic, strong) NSNumber *artworksCount;
@property (nonatomic, strong) NSString *contractType;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *defaultProfileID;
@property (nonatomic, strong) NSNumber *defaultProfilePublic;
@property (nonatomic, strong) NSNumber *directlyContactable;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *foundingPartner;
@property (nonatomic, strong) NSNumber *hasDefaultProfile;
@property (nonatomic, strong) NSNumber *hasFullProfile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *partnerID;
@property (nonatomic, strong) NSNumber *partnerLimitedAccess;
@property (nonatomic, strong) NSString *partnerType;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *representativeEmail;
@property (nonatomic, strong) NSNumber *showDocumentsCount;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *subscriptionState;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) User *admin;

@property (nonatomic, strong) NSSet *artworks;
- (NSMutableSet *)artworksSet;

@property (nonatomic, strong) NSSet *flags;
- (NSMutableSet *)flagsSet;

@property (nonatomic, strong) NSSet *subscriptionPlans;
- (NSMutableSet *)subscriptionPlansSet;


@end


@interface _Partner (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet *)value_;
- (void)removeArtworks:(NSSet *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;
@end


@interface _Partner (FlagsCoreDataGeneratedAccessors)
- (void)addFlags:(NSSet *)value_;
- (void)removeFlags:(NSSet *)value_;
- (void)addFlagsObject:(PartnerOption *)value_;
- (void)removeFlagsObject:(PartnerOption *)value_;
@end


@interface _Partner (SubscriptionPlansCoreDataGeneratedAccessors)
- (void)addSubscriptionPlans:(NSSet *)value_;
- (void)removeSubscriptionPlans:(NSSet *)value_;
- (void)addSubscriptionPlansObject:(SubscriptionPlan *)value_;
- (void)removeSubscriptionPlansObject:(SubscriptionPlan *)value_;
@end


@interface _Partner (CoreDataGeneratedPrimitiveAccessors)

- (User *)primitiveAdmin;
- (void)setPrimitiveAdmin:(User *)value;

- (NSMutableSet *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet *)value;

- (NSMutableSet *)primitiveFlags;
- (void)setPrimitiveFlags:(NSMutableSet *)value;

- (NSMutableSet *)primitiveSubscriptionPlans;
- (void)setPrimitiveSubscriptionPlans:(NSMutableSet *)value;

@end

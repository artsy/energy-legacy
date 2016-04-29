// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SubscriptionPlan.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"
extern const struct SubscriptionPlanAttributes {
    __unsafe_unretained NSString *name;
} SubscriptionPlanAttributes;

extern const struct SubscriptionPlanRelationships {
    __unsafe_unretained NSString *subscriptionForPartner;
} SubscriptionPlanRelationships;

@class Partner;


@interface SubscriptionPlanID : NSManagedObjectID {
}
@end


@interface _SubscriptionPlan : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (SubscriptionPlanID *)objectID;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Partner *subscriptionForPartner;

@end


@interface _SubscriptionPlan (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

- (Partner *)primitiveSubscriptionForPartner;
- (void)setPrimitiveSubscriptionForPartner:(Partner *)value;

@end

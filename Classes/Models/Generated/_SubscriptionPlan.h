// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SubscriptionPlan.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "ARManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class Partner;


@interface SubscriptionPlanID : NSManagedObjectID
{
}
@end


@interface _SubscriptionPlan : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) SubscriptionPlanID *objectID;

@property (nonatomic, strong, nullable) NSString *name;

@property (nonatomic, strong, nullable) Partner *subscriptionForPartner;

@end


@interface _SubscriptionPlan (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString *)primitiveName;
- (void)setPrimitiveName:(nullable NSString *)value;

- (Partner *)primitiveSubscriptionForPartner;
- (void)setPrimitiveSubscriptionForPartner:(Partner *)value;

@end


@interface SubscriptionPlanAttributes : NSObject
+ (NSString *)name;
@end


@interface SubscriptionPlanRelationships : NSObject
+ (NSString *)subscriptionForPartner;
@end

NS_ASSUME_NONNULL_END

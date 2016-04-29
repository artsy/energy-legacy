// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PartnerOption.h instead.

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


@interface PartnerOptionID : NSManagedObjectID
{
}
@end


@interface _PartnerOption : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) PartnerOptionID *objectID;

@property (nonatomic, strong, nullable) NSString *key;

@property (nonatomic, strong, nullable) NSString *value;

@property (nonatomic, strong, nullable) Partner *partner;

@end


@interface _PartnerOption (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveKey;
- (void)setPrimitiveKey:(NSString *)value;

- (NSString *)primitiveValue;
- (void)setPrimitiveValue:(NSString *)value;

- (Partner *)primitivePartner;
- (void)setPrimitivePartner:(Partner *)value;

@end


@interface PartnerOptionAttributes : NSObject
+ (NSString *)key;
+ (NSString *)value;
@end


@interface PartnerOptionRelationships : NSObject
+ (NSString *)partner;
@end

NS_ASSUME_NONNULL_END

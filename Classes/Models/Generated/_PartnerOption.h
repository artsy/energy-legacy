// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PartnerOption.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct PartnerOptionAttributes {
    __unsafe_unretained NSString *key;
    __unsafe_unretained NSString *value;
} PartnerOptionAttributes;

extern const struct PartnerOptionRelationships {
    __unsafe_unretained NSString *partner;
} PartnerOptionRelationships;

@class Partner;


@interface PartnerOptionID : NSManagedObjectID {
}
@end


@interface _PartnerOption : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (PartnerOptionID *)objectID;

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) Partner *partner;

@end


@interface _PartnerOption (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveKey;

- (void)setPrimitiveKey:(NSString *)value;

- (NSString *)primitiveValue;

- (void)setPrimitiveValue:(NSString *)value;

- (Partner *)primitivePartner;

- (void)setPrimitivePartner:(Partner *)value;

@end

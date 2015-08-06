// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct UserAttributes {
    __unsafe_unretained NSString *email;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *type;
} UserAttributes;

extern const struct UserRelationships {
    __unsafe_unretained NSString *adminForPartner;
} UserRelationships;

@class Partner;


@interface UserID : NSManagedObjectID {
}
@end


@interface _User : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (UserID *)objectID;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) Partner *adminForPartner;

@end


@interface _User (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveEmail;

- (void)setPrimitiveEmail:(NSString *)value;

- (NSString *)primitiveName;

- (void)setPrimitiveName:(NSString *)value;

- (NSString *)primitiveSlug;

- (void)setPrimitiveSlug:(NSString *)value;

- (Partner *)primitiveAdminForPartner;

- (void)setPrimitiveAdminForPartner:(Partner *)value;

@end

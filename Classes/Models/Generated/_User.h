// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

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


@interface UserID : NSManagedObjectID
{
}
@end


@interface _User : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) UserID *objectID;

@property (nonatomic, strong, nullable) NSString *email;

@property (nonatomic, strong, nullable) NSString *name;

@property (nonatomic, strong, nullable) NSString *slug;

@property (nonatomic, strong, nullable) NSString *type;

@property (nonatomic, strong, nullable) Partner *adminForPartner;

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


@interface UserAttributes : NSObject
+ (NSString *)email;
+ (NSString *)name;
+ (NSString *)slug;
+ (NSString *)type;
@end


@interface UserRelationships : NSObject
+ (NSString *)adminForPartner;
@end

NS_ASSUME_NONNULL_END

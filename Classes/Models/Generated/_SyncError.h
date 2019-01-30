// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncError.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "ARManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class SyncLog;


@interface SyncErrorID : NSManagedObjectID
{
}
@end


@interface _SyncError : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) SyncErrorID *objectID;

@property (nonatomic, strong, nullable) NSString *body;

@property (nonatomic, strong, nullable) NSString *errorType;

@property (nonatomic, strong, nullable) SyncLog *syncLog;

@end


@interface _SyncError (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString *)primitiveBody;
- (void)setPrimitiveBody:(nullable NSString *)value;

- (nullable NSString *)primitiveErrorType;
- (void)setPrimitiveErrorType:(nullable NSString *)value;

- (SyncLog *)primitiveSyncLog;
- (void)setPrimitiveSyncLog:(SyncLog *)value;

@end


@interface SyncErrorAttributes : NSObject
+ (NSString *)body;
+ (NSString *)errorType;
@end


@interface SyncErrorRelationships : NSObject
+ (NSString *)syncLog;
@end

NS_ASSUME_NONNULL_END

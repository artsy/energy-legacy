// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncError.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct SyncErrorAttributes {
    __unsafe_unretained NSString *body;
    __unsafe_unretained NSString *errorType;
} SyncErrorAttributes;

extern const struct SyncErrorRelationships {
    __unsafe_unretained NSString *syncLog;
} SyncErrorRelationships;

@class SyncLog;


@interface SyncErrorID : NSManagedObjectID {
}
@end


@interface _SyncError : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (SyncErrorID *)objectID;

@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *errorType;
@property (nonatomic, strong) SyncLog *syncLog;

@end


@interface _SyncError (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveBody;

- (void)setPrimitiveBody:(NSString *)value;

- (NSString *)primitiveErrorType;

- (void)setPrimitiveErrorType:(NSString *)value;

- (SyncLog *)primitiveSyncLog;

- (void)setPrimitiveSyncLog:(SyncLog *)value;

@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncLog.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct SyncLogAttributes {
    __unsafe_unretained NSString *albumsDelta;
    __unsafe_unretained NSString *artworkDelta;
    __unsafe_unretained NSString *dateStarted;
    __unsafe_unretained NSString *estimatedDownload;
    __unsafe_unretained NSString *showDelta;
    __unsafe_unretained NSString *timeToCompletion;
    __unsafe_unretained NSString *totalDownloaded;
} SyncLogAttributes;

extern const struct SyncLogRelationships {
    __unsafe_unretained NSString *syncErrors;
} SyncLogRelationships;

@class SyncError;


@interface SyncLogID : NSManagedObjectID {
}
@end


@interface _SyncLog : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (SyncLogID *)objectID;

@property (nonatomic, strong) NSNumber *albumsDelta;
@property (nonatomic, strong) NSNumber *artworkDelta;
@property (nonatomic, strong) NSDate *dateStarted;
@property (nonatomic, strong) NSNumber *estimatedDownload;
@property (nonatomic, strong) NSNumber *showDelta;
@property (nonatomic, strong) NSNumber *timeToCompletion;
@property (nonatomic, strong) NSNumber *totalDownloaded;
@property (nonatomic, strong) SyncError *syncErrors;

@end


@interface _SyncLog (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveAlbumsDelta;

- (void)setPrimitiveAlbumsDelta:(NSNumber *)value;

- (NSNumber *)primitiveArtworkDelta;

- (void)setPrimitiveArtworkDelta:(NSNumber *)value;

- (NSDate *)primitiveDateStarted;

- (void)setPrimitiveDateStarted:(NSDate *)value;

- (NSNumber *)primitiveEstimatedDownload;

- (void)setPrimitiveEstimatedDownload:(NSNumber *)value;

- (NSNumber *)primitiveShowDelta;

- (void)setPrimitiveShowDelta:(NSNumber *)value;

- (NSNumber *)primitiveTimeToCompletion;

- (void)setPrimitiveTimeToCompletion:(NSNumber *)value;

- (NSNumber *)primitiveTotalDownloaded;

- (void)setPrimitiveTotalDownloaded:(NSNumber *)value;

- (SyncError *)primitiveSyncErrors;

- (void)setPrimitiveSyncErrors:(SyncError *)value;

@end

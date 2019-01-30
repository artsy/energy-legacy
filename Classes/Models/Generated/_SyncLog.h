// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncLog.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "ARManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class SyncError;


@interface SyncLogID : NSManagedObjectID
{
}
@end


@interface _SyncLog : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) SyncLogID *objectID;

@property (nonatomic, strong, nullable) NSNumber *albumsDelta;

@property (atomic) int32_t albumsDeltaValue;
- (int32_t)albumsDeltaValue;
- (void)setAlbumsDeltaValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber *artworkDelta;

@property (atomic) int32_t artworkDeltaValue;
- (int32_t)artworkDeltaValue;
- (void)setArtworkDeltaValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSDate *dateStarted;

@property (nonatomic, strong, nullable) NSNumber *estimatedDownload;

@property (atomic) int64_t estimatedDownloadValue;
- (int64_t)estimatedDownloadValue;
- (void)setEstimatedDownloadValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSNumber *showDelta;

@property (atomic) int32_t showDeltaValue;
- (int32_t)showDeltaValue;
- (void)setShowDeltaValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber *timeToCompletion;

@property (atomic) int64_t timeToCompletionValue;
- (int64_t)timeToCompletionValue;
- (void)setTimeToCompletionValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSNumber *totalDownloaded;

@property (atomic) int64_t totalDownloadedValue;
- (int64_t)totalDownloadedValue;
- (void)setTotalDownloadedValue:(int64_t)value_;

@property (nonatomic, strong, nullable) SyncError *syncErrors;

@end


@interface _SyncLog (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber *)primitiveAlbumsDelta;
- (void)setPrimitiveAlbumsDelta:(nullable NSNumber *)value;

- (int32_t)primitiveAlbumsDeltaValue;
- (void)setPrimitiveAlbumsDeltaValue:(int32_t)value_;

- (nullable NSNumber *)primitiveArtworkDelta;
- (void)setPrimitiveArtworkDelta:(nullable NSNumber *)value;

- (int32_t)primitiveArtworkDeltaValue;
- (void)setPrimitiveArtworkDeltaValue:(int32_t)value_;

- (nullable NSDate *)primitiveDateStarted;
- (void)setPrimitiveDateStarted:(nullable NSDate *)value;

- (nullable NSNumber *)primitiveEstimatedDownload;
- (void)setPrimitiveEstimatedDownload:(nullable NSNumber *)value;

- (int64_t)primitiveEstimatedDownloadValue;
- (void)setPrimitiveEstimatedDownloadValue:(int64_t)value_;

- (nullable NSNumber *)primitiveShowDelta;
- (void)setPrimitiveShowDelta:(nullable NSNumber *)value;

- (int32_t)primitiveShowDeltaValue;
- (void)setPrimitiveShowDeltaValue:(int32_t)value_;

- (nullable NSNumber *)primitiveTimeToCompletion;
- (void)setPrimitiveTimeToCompletion:(nullable NSNumber *)value;

- (int64_t)primitiveTimeToCompletionValue;
- (void)setPrimitiveTimeToCompletionValue:(int64_t)value_;

- (nullable NSNumber *)primitiveTotalDownloaded;
- (void)setPrimitiveTotalDownloaded:(nullable NSNumber *)value;

- (int64_t)primitiveTotalDownloadedValue;
- (void)setPrimitiveTotalDownloadedValue:(int64_t)value_;

- (SyncError *)primitiveSyncErrors;
- (void)setPrimitiveSyncErrors:(SyncError *)value;

@end


@interface SyncLogAttributes : NSObject
+ (NSString *)albumsDelta;
+ (NSString *)artworkDelta;
+ (NSString *)dateStarted;
+ (NSString *)estimatedDownload;
+ (NSString *)showDelta;
+ (NSString *)timeToCompletion;
+ (NSString *)totalDownloaded;
@end


@interface SyncLogRelationships : NSObject
+ (NSString *)syncErrors;
@end

NS_ASSUME_NONNULL_END

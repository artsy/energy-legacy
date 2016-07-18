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
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
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

- (NSNumber *)primitiveAlbumsDelta;
- (void)setPrimitiveAlbumsDelta:(NSNumber *)value;

- (int32_t)primitiveAlbumsDeltaValue;
- (void)setPrimitiveAlbumsDeltaValue:(int32_t)value_;

- (NSNumber *)primitiveArtworkDelta;
- (void)setPrimitiveArtworkDelta:(NSNumber *)value;

- (int32_t)primitiveArtworkDeltaValue;
- (void)setPrimitiveArtworkDeltaValue:(int32_t)value_;

- (NSDate *)primitiveDateStarted;
- (void)setPrimitiveDateStarted:(NSDate *)value;

- (NSNumber *)primitiveEstimatedDownload;
- (void)setPrimitiveEstimatedDownload:(NSNumber *)value;

- (int64_t)primitiveEstimatedDownloadValue;
- (void)setPrimitiveEstimatedDownloadValue:(int64_t)value_;

- (NSNumber *)primitiveShowDelta;
- (void)setPrimitiveShowDelta:(NSNumber *)value;

- (int32_t)primitiveShowDeltaValue;
- (void)setPrimitiveShowDeltaValue:(int32_t)value_;

- (NSNumber *)primitiveTimeToCompletion;
- (void)setPrimitiveTimeToCompletion:(NSNumber *)value;

- (int64_t)primitiveTimeToCompletionValue;
- (void)setPrimitiveTimeToCompletionValue:(int64_t)value_;

- (NSNumber *)primitiveTotalDownloaded;
- (void)setPrimitiveTotalDownloaded:(NSNumber *)value;

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

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncLog.m instead.

#import "_SyncLog.h"


@implementation SyncLogID
@end


@implementation _SyncLog

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SyncLog" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"SyncLog";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SyncLog" inManagedObjectContext:moc_];
}

- (SyncLogID *)objectID
{
    return (SyncLogID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"albumsDeltaValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"albumsDelta"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"artworkDeltaValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"artworkDelta"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"estimatedDownloadValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"estimatedDownload"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"showDeltaValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"showDelta"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"timeToCompletionValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"timeToCompletion"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"totalDownloadedValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"totalDownloaded"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic albumsDelta;

- (int32_t)albumsDeltaValue
{
    NSNumber *result = [self albumsDelta];
    return [result intValue];
}

- (void)setAlbumsDeltaValue:(int32_t)value_
{
    [self setAlbumsDelta:@(value_)];
}

- (int32_t)primitiveAlbumsDeltaValue
{
    NSNumber *result = [self primitiveAlbumsDelta];
    return [result intValue];
}

- (void)setPrimitiveAlbumsDeltaValue:(int32_t)value_
{
    [self setPrimitiveAlbumsDelta:@(value_)];
}

@dynamic artworkDelta;

- (int32_t)artworkDeltaValue
{
    NSNumber *result = [self artworkDelta];
    return [result intValue];
}

- (void)setArtworkDeltaValue:(int32_t)value_
{
    [self setArtworkDelta:@(value_)];
}

- (int32_t)primitiveArtworkDeltaValue
{
    NSNumber *result = [self primitiveArtworkDelta];
    return [result intValue];
}

- (void)setPrimitiveArtworkDeltaValue:(int32_t)value_
{
    [self setPrimitiveArtworkDelta:@(value_)];
}

@dynamic dateStarted;

@dynamic estimatedDownload;

- (int64_t)estimatedDownloadValue
{
    NSNumber *result = [self estimatedDownload];
    return [result longLongValue];
}

- (void)setEstimatedDownloadValue:(int64_t)value_
{
    [self setEstimatedDownload:@(value_)];
}

- (int64_t)primitiveEstimatedDownloadValue
{
    NSNumber *result = [self primitiveEstimatedDownload];
    return [result longLongValue];
}

- (void)setPrimitiveEstimatedDownloadValue:(int64_t)value_
{
    [self setPrimitiveEstimatedDownload:@(value_)];
}

@dynamic showDelta;

- (int32_t)showDeltaValue
{
    NSNumber *result = [self showDelta];
    return [result intValue];
}

- (void)setShowDeltaValue:(int32_t)value_
{
    [self setShowDelta:@(value_)];
}

- (int32_t)primitiveShowDeltaValue
{
    NSNumber *result = [self primitiveShowDelta];
    return [result intValue];
}

- (void)setPrimitiveShowDeltaValue:(int32_t)value_
{
    [self setPrimitiveShowDelta:@(value_)];
}

@dynamic timeToCompletion;

- (int64_t)timeToCompletionValue
{
    NSNumber *result = [self timeToCompletion];
    return [result longLongValue];
}

- (void)setTimeToCompletionValue:(int64_t)value_
{
    [self setTimeToCompletion:@(value_)];
}

- (int64_t)primitiveTimeToCompletionValue
{
    NSNumber *result = [self primitiveTimeToCompletion];
    return [result longLongValue];
}

- (void)setPrimitiveTimeToCompletionValue:(int64_t)value_
{
    [self setPrimitiveTimeToCompletion:@(value_)];
}

@dynamic totalDownloaded;

- (int64_t)totalDownloadedValue
{
    NSNumber *result = [self totalDownloaded];
    return [result longLongValue];
}

- (void)setTotalDownloadedValue:(int64_t)value_
{
    [self setTotalDownloaded:@(value_)];
}

- (int64_t)primitiveTotalDownloadedValue
{
    NSNumber *result = [self primitiveTotalDownloaded];
    return [result longLongValue];
}

- (void)setPrimitiveTotalDownloadedValue:(int64_t)value_
{
    [self setPrimitiveTotalDownloaded:@(value_)];
}

@dynamic syncErrors;

@end


@implementation SyncLogAttributes
+ (NSString *)albumsDelta
{
    return @"albumsDelta";
}
+ (NSString *)artworkDelta
{
    return @"artworkDelta";
}
+ (NSString *)dateStarted
{
    return @"dateStarted";
}
+ (NSString *)estimatedDownload
{
    return @"estimatedDownload";
}
+ (NSString *)showDelta
{
    return @"showDelta";
}
+ (NSString *)timeToCompletion
{
    return @"timeToCompletion";
}
+ (NSString *)totalDownloaded
{
    return @"totalDownloaded";
}
@end


@implementation SyncLogRelationships
+ (NSString *)syncErrors
{
    return @"syncErrors";
}
@end

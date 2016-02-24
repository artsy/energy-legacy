// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncLog.m instead.

#import "_SyncLog.h"

const struct SyncLogAttributes SyncLogAttributes = {
    .albumsDelta = @"albumsDelta",
    .artworkDelta = @"artworkDelta",
    .dateStarted = @"dateStarted",
    .estimatedDownload = @"estimatedDownload",
    .showDelta = @"showDelta",
    .timeToCompletion = @"timeToCompletion",
    .totalDownloaded = @"totalDownloaded",
};

const struct SyncLogRelationships SyncLogRelationships = {
    .syncErrors = @"syncErrors",
};

const struct SyncLogUserInfo SyncLogUserInfo = {};


@implementation SyncLogID
@end


@implementation _SyncLog

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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


@dynamic albumsDelta;
@dynamic artworkDelta;
@dynamic dateStarted;
@dynamic estimatedDownload;
@dynamic showDelta;
@dynamic timeToCompletion;
@dynamic totalDownloaded;


@dynamic syncErrors;


@end

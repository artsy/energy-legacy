// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncError.m instead.

#import "_SyncError.h"

const struct SyncErrorAttributes SyncErrorAttributes = {
    .body = @"body",
    .errorType = @"errorType",
};

const struct SyncErrorRelationships SyncErrorRelationships = {
    .syncLog = @"syncLog",
};


@implementation SyncErrorID
@end


@implementation _SyncError

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SyncError" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"SyncError";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SyncError" inManagedObjectContext:moc_];
}

- (SyncErrorID *)objectID
{
    return (SyncErrorID *)[super objectID];
}

@dynamic body;
@dynamic errorType;

@dynamic syncLog;

@end

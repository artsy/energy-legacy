// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncError.m instead.

#import "_SyncError.h"


@implementation SyncErrorID
@end


@implementation _SyncError

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@dynamic body;

@dynamic errorType;

@dynamic syncLog;

@end


@implementation SyncErrorAttributes
+ (NSString *)body
{
    return @"body";
}
+ (NSString *)errorType
{
    return @"errorType";
}
@end


@implementation SyncErrorRelationships
+ (NSString *)syncLog
{
    return @"syncLog";
}
@end

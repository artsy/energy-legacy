// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumDelete.m instead.

#import "_AlbumDelete.h"


@implementation AlbumDeleteID
@end


@implementation _AlbumDelete

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"AlbumDelete" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"AlbumDelete";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"AlbumDelete" inManagedObjectContext:moc_];
}

- (AlbumDeleteID *)objectID
{
    return (AlbumDeleteID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@dynamic albumID;

@dynamic createdAt;

@end


@implementation AlbumDeleteAttributes
+ (NSString *)albumID
{
    return @"albumID";
}
+ (NSString *)createdAt
{
    return @"createdAt";
}
@end

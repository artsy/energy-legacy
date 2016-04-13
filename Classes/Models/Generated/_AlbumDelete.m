// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumDelete.m instead.

#import "_AlbumDelete.h"

const struct AlbumDeleteAttributes AlbumDeleteAttributes = {
    .albumID = @"albumID",
    .createdAt = @"createdAt",
};


@implementation AlbumDeleteID
@end


@implementation _AlbumDelete

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

@dynamic albumID;
@dynamic createdAt;

@end

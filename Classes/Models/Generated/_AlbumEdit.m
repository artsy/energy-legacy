// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumEdit.m instead.

#import "_AlbumEdit.h"

const struct AlbumEditAttributes AlbumEditAttributes = {
    .albumWasCreated = @"albumWasCreated",
    .createdAt = @"createdAt",
};

const struct AlbumEditRelationships AlbumEditRelationships = {
    .addedArtworks = @"addedArtworks",
    .album = @"album",
    .removedArtworks = @"removedArtworks",
};


@implementation AlbumEditID
@end


@implementation _AlbumEdit

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"AlbumEdit" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"AlbumEdit";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"AlbumEdit" inManagedObjectContext:moc_];
}

- (AlbumEditID *)objectID
{
    return (AlbumEditID *)[super objectID];
}

@dynamic albumWasCreated;
@dynamic createdAt;

@dynamic addedArtworks;
- (NSMutableSet *)addedArtworksSet
{
    [self willAccessValueForKey:@"addedArtworks"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"addedArtworks"];
    [self didAccessValueForKey:@"addedArtworks"];
    return result;
}

@dynamic album;
@dynamic removedArtworks;
- (NSMutableSet *)removedArtworksSet
{
    [self willAccessValueForKey:@"removedArtworks"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"removedArtworks"];
    [self didAccessValueForKey:@"removedArtworks"];
    return result;
}

@end

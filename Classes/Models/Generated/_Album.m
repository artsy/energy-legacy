// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Album.m instead.

#import "_Album.h"

const struct AlbumAttributes AlbumAttributes = {
    .createdAt = @"createdAt",
    .editable = @"editable",
    .hasBeenEdited = @"hasBeenEdited",
    .isPrivate = @"isPrivate",
    .name = @"name",
    .slug = @"slug",
    .sortKey = @"sortKey",
    .summary = @"summary",
    .type = @"type",
    .updatedAt = @"updatedAt",
};

const struct AlbumRelationships AlbumRelationships = {
    .artists = @"artists",
    .artworks = @"artworks",
    .cover = @"cover",
    .documents = @"documents",
    .uploadRecord = @"uploadRecord",
};


@implementation AlbumID
@end


@implementation _Album

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Album";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Album" inManagedObjectContext:moc_];
}

- (AlbumID *)objectID
{
    return (AlbumID *)[super objectID];
}

@dynamic createdAt;
@dynamic editable;
@dynamic hasBeenEdited;
@dynamic isPrivate;
@dynamic name;
@dynamic slug;
@dynamic sortKey;
@dynamic summary;
@dynamic type;
@dynamic updatedAt;

@dynamic artists;
- (NSMutableSet *)artistsSet
{
    [self willAccessValueForKey:@"artists"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"artists"];
    [self didAccessValueForKey:@"artists"];
    return result;
}

@dynamic artworks;
- (NSMutableSet *)artworksSet
{
    [self willAccessValueForKey:@"artworks"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"artworks"];
    [self didAccessValueForKey:@"artworks"];
    return result;
}

@dynamic cover;
@dynamic documents;
- (NSMutableSet *)documentsSet
{
    [self willAccessValueForKey:@"documents"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"documents"];
    [self didAccessValueForKey:@"documents"];
    return result;
}

@dynamic uploadRecord;

@end

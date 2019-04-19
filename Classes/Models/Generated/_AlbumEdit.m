// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumEdit.m instead.

#import "_AlbumEdit.h"


@implementation AlbumEditID
@end


@implementation _AlbumEdit

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"albumWasCreatedValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"albumWasCreated"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"deleteAlbumAfterSyncValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"deleteAlbumAfterSync"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic albumWasCreated;

- (BOOL)albumWasCreatedValue
{
    NSNumber *result = [self albumWasCreated];
    return [result boolValue];
}

- (void)setAlbumWasCreatedValue:(BOOL)value_
{
    [self setAlbumWasCreated:@(value_)];
}

- (BOOL)primitiveAlbumWasCreatedValue
{
    NSNumber *result = [self primitiveAlbumWasCreated];
    return [result boolValue];
}

- (void)setPrimitiveAlbumWasCreatedValue:(BOOL)value_
{
    [self setPrimitiveAlbumWasCreated:@(value_)];
}

@dynamic createdAt;

@dynamic deleteAlbumAfterSync;

- (BOOL)deleteAlbumAfterSyncValue
{
    NSNumber *result = [self deleteAlbumAfterSync];
    return [result boolValue];
}

- (void)setDeleteAlbumAfterSyncValue:(BOOL)value_
{
    [self setDeleteAlbumAfterSync:@(value_)];
}

- (BOOL)primitiveDeleteAlbumAfterSyncValue
{
    NSNumber *result = [self primitiveDeleteAlbumAfterSync];
    return [result boolValue];
}

- (void)setPrimitiveDeleteAlbumAfterSyncValue:(BOOL)value_
{
    [self setPrimitiveDeleteAlbumAfterSync:@(value_)];
}

@dynamic addedArtworks;

- (NSMutableSet<Artwork *> *)addedArtworksSet
{
    [self willAccessValueForKey:@"addedArtworks"];

    NSMutableSet<Artwork *> *result = (NSMutableSet<Artwork *> *)[self mutableSetValueForKey:@"addedArtworks"];

    [self didAccessValueForKey:@"addedArtworks"];
    return result;
}

@dynamic album;

@dynamic removedArtworks;

- (NSMutableSet<Artwork *> *)removedArtworksSet
{
    [self willAccessValueForKey:@"removedArtworks"];

    NSMutableSet<Artwork *> *result = (NSMutableSet<Artwork *> *)[self mutableSetValueForKey:@"removedArtworks"];

    [self didAccessValueForKey:@"removedArtworks"];
    return result;
}

@end


@implementation AlbumEditAttributes
+ (NSString *)albumWasCreated
{
    return @"albumWasCreated";
}
+ (NSString *)createdAt
{
    return @"createdAt";
}
+ (NSString *)deleteAlbumAfterSync
{
    return @"deleteAlbumAfterSync";
}
@end


@implementation AlbumEditRelationships
+ (NSString *)addedArtworks
{
    return @"addedArtworks";
}
+ (NSString *)album
{
    return @"album";
}
+ (NSString *)removedArtworks
{
    return @"removedArtworks";
}
@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Album.m instead.

#import "_Album.h"


@implementation AlbumID
@end


@implementation _Album

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"editableValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"editable"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"hasBeenEditedValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"hasBeenEdited"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"isPrivateValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"isPrivate"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"sortKeyValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"sortKey"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic createdAt;

@dynamic editable;

- (BOOL)editableValue
{
    NSNumber *result = [self editable];
    return [result boolValue];
}

- (void)setEditableValue:(BOOL)value_
{
    [self setEditable:@(value_)];
}

- (BOOL)primitiveEditableValue
{
    NSNumber *result = [self primitiveEditable];
    return [result boolValue];
}

- (void)setPrimitiveEditableValue:(BOOL)value_
{
    [self setPrimitiveEditable:@(value_)];
}

@dynamic hasBeenEdited;

- (BOOL)hasBeenEditedValue
{
    NSNumber *result = [self hasBeenEdited];
    return [result boolValue];
}

- (void)setHasBeenEditedValue:(BOOL)value_
{
    [self setHasBeenEdited:@(value_)];
}

- (BOOL)primitiveHasBeenEditedValue
{
    NSNumber *result = [self primitiveHasBeenEdited];
    return [result boolValue];
}

- (void)setPrimitiveHasBeenEditedValue:(BOOL)value_
{
    [self setPrimitiveHasBeenEdited:@(value_)];
}

@dynamic isPrivate;

- (BOOL)isPrivateValue
{
    NSNumber *result = [self isPrivate];
    return [result boolValue];
}

- (void)setIsPrivateValue:(BOOL)value_
{
    [self setIsPrivate:@(value_)];
}

- (BOOL)primitiveIsPrivateValue
{
    NSNumber *result = [self primitiveIsPrivate];
    return [result boolValue];
}

- (void)setPrimitiveIsPrivateValue:(BOOL)value_
{
    [self setPrimitiveIsPrivate:@(value_)];
}

@dynamic name;

@dynamic slug;

@dynamic sortKey;

- (int16_t)sortKeyValue
{
    NSNumber *result = [self sortKey];
    return [result shortValue];
}

- (void)setSortKeyValue:(int16_t)value_
{
    [self setSortKey:@(value_)];
}

- (int16_t)primitiveSortKeyValue
{
    NSNumber *result = [self primitiveSortKey];
    return [result shortValue];
}

- (void)setPrimitiveSortKeyValue:(int16_t)value_
{
    [self setPrimitiveSortKey:@(value_)];
}

@dynamic summary;

@dynamic type;

@dynamic updatedAt;

@dynamic artists;

- (NSMutableSet<Artist *> *)artistsSet
{
    [self willAccessValueForKey:@"artists"];

    NSMutableSet<Artist *> *result = (NSMutableSet<Artist *> *)[self mutableSetValueForKey:@"artists"];

    [self didAccessValueForKey:@"artists"];
    return result;
}

@dynamic artworks;

- (NSMutableSet<Artwork *> *)artworksSet
{
    [self willAccessValueForKey:@"artworks"];

    NSMutableSet<Artwork *> *result = (NSMutableSet<Artwork *> *)[self mutableSetValueForKey:@"artworks"];

    [self didAccessValueForKey:@"artworks"];
    return result;
}

@dynamic cover;

@dynamic documents;

- (NSMutableSet<Document *> *)documentsSet
{
    [self willAccessValueForKey:@"documents"];

    NSMutableSet<Document *> *result = (NSMutableSet<Document *> *)[self mutableSetValueForKey:@"documents"];

    [self didAccessValueForKey:@"documents"];
    return result;
}

@dynamic uploadRecord;

@end


@implementation AlbumAttributes
+ (NSString *)createdAt
{
    return @"createdAt";
}
+ (NSString *)editable
{
    return @"editable";
}
+ (NSString *)hasBeenEdited
{
    return @"hasBeenEdited";
}
+ (NSString *)isPrivate
{
    return @"isPrivate";
}
+ (NSString *)name
{
    return @"name";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)sortKey
{
    return @"sortKey";
}
+ (NSString *)summary
{
    return @"summary";
}
+ (NSString *)type
{
    return @"type";
}
+ (NSString *)updatedAt
{
    return @"updatedAt";
}
@end


@implementation AlbumRelationships
+ (NSString *)artists
{
    return @"artists";
}
+ (NSString *)artworks
{
    return @"artworks";
}
+ (NSString *)cover
{
    return @"cover";
}
+ (NSString *)documents
{
    return @"documents";
}
+ (NSString *)uploadRecord
{
    return @"uploadRecord";
}
@end

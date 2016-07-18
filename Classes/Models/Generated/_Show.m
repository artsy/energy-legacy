// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Show.m instead.

#import "_Show.h"


@implementation ShowID
@end


@implementation _Show

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Show" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Show";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Show" inManagedObjectContext:moc_];
}

- (ShowID *)objectID
{
    return (ShowID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"sortKeyValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"sortKey"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic availabilityPeriod;

@dynamic createdAt;

@dynamic endsAt;

@dynamic name;

@dynamic showSlug;

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

@dynamic startsAt;

@dynamic status;

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

@dynamic installationImages;

- (NSMutableSet<InstallShotImage *> *)installationImagesSet
{
    [self willAccessValueForKey:@"installationImages"];

    NSMutableSet<InstallShotImage *> *result = (NSMutableSet<InstallShotImage *> *)[self mutableSetValueForKey:@"installationImages"];

    [self didAccessValueForKey:@"installationImages"];
    return result;
}

@dynamic location;

@end


@implementation ShowAttributes
+ (NSString *)availabilityPeriod
{
    return @"availabilityPeriod";
}
+ (NSString *)createdAt
{
    return @"createdAt";
}
+ (NSString *)endsAt
{
    return @"endsAt";
}
+ (NSString *)name
{
    return @"name";
}
+ (NSString *)showSlug
{
    return @"showSlug";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)sortKey
{
    return @"sortKey";
}
+ (NSString *)startsAt
{
    return @"startsAt";
}
+ (NSString *)status
{
    return @"status";
}
+ (NSString *)updatedAt
{
    return @"updatedAt";
}
@end


@implementation ShowRelationships
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
+ (NSString *)installationImages
{
    return @"installationImages";
}
+ (NSString *)location
{
    return @"location";
}
@end

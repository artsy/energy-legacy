// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Location.m instead.

#import "_Location.h"


@implementation LocationID
@end


@implementation _Location

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Location";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Location" inManagedObjectContext:moc_];
}

- (LocationID *)objectID
{
    return (LocationID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@dynamic address;

@dynamic addressSecond;

@dynamic city;

@dynamic geoPoint;

@dynamic name;

@dynamic phone;

@dynamic postalCode;

@dynamic slug;

@dynamic state;

@dynamic artworks;

- (NSMutableSet<Artwork *> *)artworksSet
{
    [self willAccessValueForKey:@"artworks"];

    NSMutableSet<Artwork *> *result = (NSMutableSet<Artwork *> *)[self mutableSetValueForKey:@"artworks"];

    [self didAccessValueForKey:@"artworks"];
    return result;
}

@dynamic shows;

- (NSMutableSet<Show *> *)showsSet
{
    [self willAccessValueForKey:@"shows"];

    NSMutableSet<Show *> *result = (NSMutableSet<Show *> *)[self mutableSetValueForKey:@"shows"];

    [self didAccessValueForKey:@"shows"];
    return result;
}

@end


@implementation LocationAttributes
+ (NSString *)address
{
    return @"address";
}
+ (NSString *)addressSecond
{
    return @"addressSecond";
}
+ (NSString *)city
{
    return @"city";
}
+ (NSString *)geoPoint
{
    return @"geoPoint";
}
+ (NSString *)name
{
    return @"name";
}
+ (NSString *)phone
{
    return @"phone";
}
+ (NSString *)postalCode
{
    return @"postalCode";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)state
{
    return @"state";
}
@end


@implementation LocationRelationships
+ (NSString *)artworks
{
    return @"artworks";
}
+ (NSString *)shows
{
    return @"shows";
}
@end

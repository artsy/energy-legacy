// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Location.m instead.

#import "_Location.h"

const struct LocationAttributes LocationAttributes = {
    .address = @"address",
    .addressSecond = @"addressSecond",
    .city = @"city",
    .geoPoint = @"geoPoint",
    .name = @"name",
    .phone = @"phone",
    .postalCode = @"postalCode",
    .slug = @"slug",
    .state = @"state",
};

const struct LocationRelationships LocationRelationships = {
    .artworks = @"artworks",
    .shows = @"shows",
};


@implementation LocationID
@end


@implementation _Location

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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
- (NSMutableSet *)artworksSet
{
    [self willAccessValueForKey:@"artworks"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"artworks"];
    [self didAccessValueForKey:@"artworks"];
    return result;
}

@dynamic shows;
- (NSMutableSet *)showsSet
{
    [self willAccessValueForKey:@"shows"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"shows"];
    [self didAccessValueForKey:@"shows"];
    return result;
}

@end

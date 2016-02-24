// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Show.m instead.

#import "_Show.h"

const struct ShowAttributes ShowAttributes = {
    .availabilityPeriod = @"availabilityPeriod",
    .createdAt = @"createdAt",
    .endsAt = @"endsAt",
    .name = @"name",
    .showSlug = @"showSlug",
    .slug = @"slug",
    .sortKey = @"sortKey",
    .startsAt = @"startsAt",
    .status = @"status",
    .updatedAt = @"updatedAt",
};

const struct ShowRelationships ShowRelationships = {
    .artists = @"artists",
    .artworks = @"artworks",
    .cover = @"cover",
    .documents = @"documents",
    .installationImages = @"installationImages",
    .location = @"location",
};

const struct ShowUserInfo ShowUserInfo = {};


@implementation ShowID
@end


@implementation _Show

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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


@dynamic availabilityPeriod;
@dynamic createdAt;
@dynamic endsAt;
@dynamic name;
@dynamic showSlug;
@dynamic slug;
@dynamic sortKey;
@dynamic startsAt;
@dynamic status;
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

@dynamic installationImages;
- (NSMutableSet *)installationImagesSet
{
    [self willAccessValueForKey:@"installationImages"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"installationImages"];
    [self didAccessValueForKey:@"installationImages"];
    return result;
}

@dynamic location;


@end

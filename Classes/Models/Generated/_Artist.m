// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Artist.m instead.

#import "_Artist.h"

const struct ArtistAttributes ArtistAttributes = {
    .awards = @"awards",
    .biography = @"biography",
    .blurb = @"blurb",
    .createdAt = @"createdAt",
    .deathDate = @"deathDate",
    .displayName = @"displayName",
    .firstName = @"firstName",
    .hometown = @"hometown",
    .lastName = @"lastName",
    .middleName = @"middleName",
    .name = @"name",
    .nationality = @"nationality",
    .orderingKey = @"orderingKey",
    .slug = @"slug",
    .statement = @"statement",
    .thumbnailBaseURL = @"thumbnailBaseURL",
    .updatedAt = @"updatedAt",
    .years = @"years",
};

const struct ArtistRelationships ArtistRelationships = {
    .albumsFeaturingArtist = @"albumsFeaturingArtist",
    .artworks = @"artworks",
    .cover = @"cover",
    .documents = @"documents",
    .installShotsFeaturingArtist = @"installShotsFeaturingArtist",
    .showsFeaturingArtist = @"showsFeaturingArtist",
};


@implementation ArtistID
@end


@implementation _Artist

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Artist";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:moc_];
}

- (ArtistID *)objectID
{
    return (ArtistID *)[super objectID];
}

@dynamic awards;
@dynamic biography;
@dynamic blurb;
@dynamic createdAt;
@dynamic deathDate;
@dynamic displayName;
@dynamic firstName;
@dynamic hometown;
@dynamic lastName;
@dynamic middleName;
@dynamic name;
@dynamic nationality;
@dynamic orderingKey;
@dynamic slug;
@dynamic statement;
@dynamic thumbnailBaseURL;
@dynamic updatedAt;
@dynamic years;

@dynamic albumsFeaturingArtist;

- (NSMutableSet *)albumsFeaturingArtistSet
{
    [self willAccessValueForKey:@"albumsFeaturingArtist"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"albumsFeaturingArtist"];
    [self didAccessValueForKey:@"albumsFeaturingArtist"];
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

@dynamic installShotsFeaturingArtist;
@dynamic showsFeaturingArtist;

- (NSMutableSet *)showsFeaturingArtistSet
{
    [self willAccessValueForKey:@"showsFeaturingArtist"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"showsFeaturingArtist"];
    [self didAccessValueForKey:@"showsFeaturingArtist"];
    return result;
}

@end

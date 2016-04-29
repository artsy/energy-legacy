// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Artist.m instead.

#import "_Artist.h"


@implementation ArtistID
@end


@implementation _Artist

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
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

- (NSMutableSet<Album *> *)albumsFeaturingArtistSet
{
    [self willAccessValueForKey:@"albumsFeaturingArtist"];

    NSMutableSet<Album *> *result = (NSMutableSet<Album *> *)[self mutableSetValueForKey:@"albumsFeaturingArtist"];

    [self didAccessValueForKey:@"albumsFeaturingArtist"];
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

@dynamic installShotsFeaturingArtist;

@dynamic showsFeaturingArtist;

- (NSMutableSet<Show *> *)showsFeaturingArtistSet
{
    [self willAccessValueForKey:@"showsFeaturingArtist"];

    NSMutableSet<Show *> *result = (NSMutableSet<Show *> *)[self mutableSetValueForKey:@"showsFeaturingArtist"];

    [self didAccessValueForKey:@"showsFeaturingArtist"];
    return result;
}

@end


@implementation ArtistAttributes
+ (NSString *)awards
{
    return @"awards";
}
+ (NSString *)biography
{
    return @"biography";
}
+ (NSString *)blurb
{
    return @"blurb";
}
+ (NSString *)createdAt
{
    return @"createdAt";
}
+ (NSString *)deathDate
{
    return @"deathDate";
}
+ (NSString *)displayName
{
    return @"displayName";
}
+ (NSString *)firstName
{
    return @"firstName";
}
+ (NSString *)hometown
{
    return @"hometown";
}
+ (NSString *)lastName
{
    return @"lastName";
}
+ (NSString *)middleName
{
    return @"middleName";
}
+ (NSString *)name
{
    return @"name";
}
+ (NSString *)nationality
{
    return @"nationality";
}
+ (NSString *)orderingKey
{
    return @"orderingKey";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)statement
{
    return @"statement";
}
+ (NSString *)thumbnailBaseURL
{
    return @"thumbnailBaseURL";
}
+ (NSString *)updatedAt
{
    return @"updatedAt";
}
+ (NSString *)years
{
    return @"years";
}
@end


@implementation ArtistRelationships
+ (NSString *)albumsFeaturingArtist
{
    return @"albumsFeaturingArtist";
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
+ (NSString *)installShotsFeaturingArtist
{
    return @"installShotsFeaturingArtist";
}
+ (NSString *)showsFeaturingArtist
{
    return @"showsFeaturingArtist";
}
@end

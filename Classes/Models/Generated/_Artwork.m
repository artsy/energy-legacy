// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Artwork.m instead.

#import "_Artwork.h"


@implementation ArtworkID
@end


@implementation _Artwork

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Artwork" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Artwork";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Artwork" inManagedObjectContext:moc_];
}

- (ArtworkID *)objectID
{
    return (ArtworkID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"isAvailableForSaleValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"isAvailableForSale"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"isPriceHiddenValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"isPriceHidden"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"isPublishedValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"isPublished"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic artistOrderingKey;

@dynamic availability;

@dynamic backendPrice;

@dynamic category;

@dynamic confidentialNotes;

@dynamic createdAt;

@dynamic date;

@dynamic depth;

@dynamic diameter;

@dynamic dimensionsCM;

@dynamic dimensionsInches;

@dynamic displayPrice;

@dynamic displayTitle;

@dynamic editions;

@dynamic exhibitionHistory;

@dynamic height;

@dynamic imageRights;

@dynamic info;

@dynamic inventoryID;

@dynamic isAvailableForSale;

- (BOOL)isAvailableForSaleValue
{
    NSNumber *result = [self isAvailableForSale];
    return [result boolValue];
}

- (void)setIsAvailableForSaleValue:(BOOL)value_
{
    [self setIsAvailableForSale:@(value_)];
}

- (BOOL)primitiveIsAvailableForSaleValue
{
    NSNumber *result = [self primitiveIsAvailableForSale];
    return [result boolValue];
}

- (void)setPrimitiveIsAvailableForSaleValue:(BOOL)value_
{
    [self setPrimitiveIsAvailableForSale:@(value_)];
}

@dynamic isPriceHidden;

- (BOOL)isPriceHiddenValue
{
    NSNumber *result = [self isPriceHidden];
    return [result boolValue];
}

- (void)setIsPriceHiddenValue:(BOOL)value_
{
    [self setIsPriceHidden:@(value_)];
}

- (BOOL)primitiveIsPriceHiddenValue
{
    NSNumber *result = [self primitiveIsPriceHidden];
    return [result boolValue];
}

- (void)setPrimitiveIsPriceHiddenValue:(BOOL)value_
{
    [self setPrimitiveIsPriceHidden:@(value_)];
}

@dynamic isPublished;

- (BOOL)isPublishedValue
{
    NSNumber *result = [self isPublished];
    return [result boolValue];
}

- (void)setIsPublishedValue:(BOOL)value_
{
    [self setIsPublished:@(value_)];
}

- (BOOL)primitiveIsPublishedValue
{
    NSNumber *result = [self primitiveIsPublished];
    return [result boolValue];
}

- (void)setPrimitiveIsPublishedValue:(BOOL)value_
{
    [self setPrimitiveIsPublished:@(value_)];
}

@dynamic literature;

@dynamic medium;

@dynamic provenance;

@dynamic series;

@dynamic signature;

@dynamic slug;

@dynamic title;

@dynamic updatedAt;

@dynamic width;

@dynamic artist;

@dynamic artists;

- (NSMutableSet<Artist *> *)artistsSet
{
    [self willAccessValueForKey:@"artists"];

    NSMutableSet<Artist *> *result = (NSMutableSet<Artist *> *)[self mutableSetValueForKey:@"artists"];

    [self didAccessValueForKey:@"artists"];
    return result;
}

@dynamic collections;

- (NSMutableSet<Album *> *)collectionsSet
{
    [self willAccessValueForKey:@"collections"];

    NSMutableSet<Album *> *result = (NSMutableSet<Album *> *)[self mutableSetValueForKey:@"collections"];

    [self didAccessValueForKey:@"collections"];
    return result;
}

@dynamic editionSets;

- (NSMutableSet<EditionSet *> *)editionSetsSet
{
    [self willAccessValueForKey:@"editionSets"];

    NSMutableSet<EditionSet *> *result = (NSMutableSet<EditionSet *> *)[self mutableSetValueForKey:@"editionSets"];

    [self didAccessValueForKey:@"editionSets"];
    return result;
}

@dynamic images;

- (NSMutableSet<Image *> *)imagesSet
{
    [self willAccessValueForKey:@"images"];

    NSMutableSet<Image *> *result = (NSMutableSet<Image *> *)[self mutableSetValueForKey:@"images"];

    [self didAccessValueForKey:@"images"];
    return result;
}

@dynamic installShotsFeaturingArtwork;

- (NSMutableSet<Image *> *)installShotsFeaturingArtworkSet
{
    [self willAccessValueForKey:@"installShotsFeaturingArtwork"];

    NSMutableSet<Image *> *result = (NSMutableSet<Image *> *)[self mutableSetValueForKey:@"installShotsFeaturingArtwork"];

    [self didAccessValueForKey:@"installShotsFeaturingArtwork"];
    return result;
}

@dynamic locations;

- (NSMutableSet<Location *> *)locationsSet
{
    [self willAccessValueForKey:@"locations"];

    NSMutableSet<Location *> *result = (NSMutableSet<Location *> *)[self mutableSetValueForKey:@"locations"];

    [self didAccessValueForKey:@"locations"];
    return result;
}

@dynamic mainImage;

@dynamic notes;

@dynamic partner;

@dynamic shows;

- (NSMutableSet<Show *> *)showsSet
{
    [self willAccessValueForKey:@"shows"];

    NSMutableSet<Show *> *result = (NSMutableSet<Show *> *)[self mutableSetValueForKey:@"shows"];

    [self didAccessValueForKey:@"shows"];
    return result;
}

@end


@implementation ArtworkAttributes
+ (NSString *)artistOrderingKey
{
    return @"artistOrderingKey";
}
+ (NSString *)availability
{
    return @"availability";
}
+ (NSString *)backendPrice
{
    return @"backendPrice";
}
+ (NSString *)category
{
    return @"category";
}
+ (NSString *)confidentialNotes
{
    return @"confidentialNotes";
}
+ (NSString *)createdAt
{
    return @"createdAt";
}
+ (NSString *)date
{
    return @"date";
}
+ (NSString *)depth
{
    return @"depth";
}
+ (NSString *)diameter
{
    return @"diameter";
}
+ (NSString *)dimensionsCM
{
    return @"dimensionsCM";
}
+ (NSString *)dimensionsInches
{
    return @"dimensionsInches";
}
+ (NSString *)displayPrice
{
    return @"displayPrice";
}
+ (NSString *)displayTitle
{
    return @"displayTitle";
}
+ (NSString *)editions
{
    return @"editions";
}
+ (NSString *)exhibitionHistory
{
    return @"exhibitionHistory";
}
+ (NSString *)height
{
    return @"height";
}
+ (NSString *)imageRights
{
    return @"imageRights";
}
+ (NSString *)info
{
    return @"info";
}
+ (NSString *)inventoryID
{
    return @"inventoryID";
}
+ (NSString *)isAvailableForSale
{
    return @"isAvailableForSale";
}
+ (NSString *)isPriceHidden
{
    return @"isPriceHidden";
}
+ (NSString *)isPublished
{
    return @"isPublished";
}
+ (NSString *)literature
{
    return @"literature";
}
+ (NSString *)medium
{
    return @"medium";
}
+ (NSString *)provenance
{
    return @"provenance";
}
+ (NSString *)series
{
    return @"series";
}
+ (NSString *)signature
{
    return @"signature";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)title
{
    return @"title";
}
+ (NSString *)updatedAt
{
    return @"updatedAt";
}
+ (NSString *)width
{
    return @"width";
}
@end


@implementation ArtworkRelationships
+ (NSString *)artist
{
    return @"artist";
}
+ (NSString *)artists
{
    return @"artists";
}
+ (NSString *)collections
{
    return @"collections";
}
+ (NSString *)editionSets
{
    return @"editionSets";
}
+ (NSString *)images
{
    return @"images";
}
+ (NSString *)installShotsFeaturingArtwork
{
    return @"installShotsFeaturingArtwork";
}
+ (NSString *)locations
{
    return @"locations";
}
+ (NSString *)mainImage
{
    return @"mainImage";
}
+ (NSString *)notes
{
    return @"notes";
}
+ (NSString *)partner
{
    return @"partner";
}
+ (NSString *)shows
{
    return @"shows";
}
@end

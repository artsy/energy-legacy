// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Artwork.m instead.

#import "_Artwork.h"

const struct ArtworkAttributes ArtworkAttributes = {
    .availability = @"availability",
    .backendPrice = @"backendPrice",
    .category = @"category",
    .confidentialNotes = @"confidentialNotes",
    .createdAt = @"createdAt",
    .date = @"date",
    .depth = @"depth",
    .diameter = @"diameter",
    .dimensionsCM = @"dimensionsCM",
    .dimensionsInches = @"dimensionsInches",
    .displayPrice = @"displayPrice",
    .displayTitle = @"displayTitle",
    .editions = @"editions",
    .exhibitionHistory = @"exhibitionHistory",
    .height = @"height",
    .imageRights = @"imageRights",
    .info = @"info",
    .inventoryID = @"inventoryID",
    .isAvailableForSale = @"isAvailableForSale",
    .isPriceHidden = @"isPriceHidden",
    .isPublished = @"isPublished",
    .literature = @"literature",
    .medium = @"medium",
    .provenance = @"provenance",
    .series = @"series",
    .signature = @"signature",
    .slug = @"slug",
    .title = @"title",
    .updatedAt = @"updatedAt",
    .width = @"width",
};

const struct ArtworkRelationships ArtworkRelationships = {
    .artist = @"artist",
    .collections = @"collections",
    .editionSets = @"editionSets",
    .images = @"images",
    .installShotsFeaturingArtwork = @"installShotsFeaturingArtwork",
    .locations = @"locations",
    .mainImage = @"mainImage",
    .notes = @"notes",
    .partner = @"partner",
    .shows = @"shows",
};

const struct ArtworkUserInfo ArtworkUserInfo = {};


@implementation ArtworkID
@end


@implementation _Artwork

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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
@dynamic isPriceHidden;
@dynamic isPublished;
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
@dynamic collections;
- (NSMutableSet *)collectionsSet
{
    [self willAccessValueForKey:@"collections"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"collections"];
    [self didAccessValueForKey:@"collections"];
    return result;
}

@dynamic editionSets;
- (NSMutableSet *)editionSetsSet
{
    [self willAccessValueForKey:@"editionSets"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"editionSets"];
    [self didAccessValueForKey:@"editionSets"];
    return result;
}

@dynamic images;
- (NSMutableSet *)imagesSet
{
    [self willAccessValueForKey:@"images"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"images"];
    [self didAccessValueForKey:@"images"];
    return result;
}

@dynamic installShotsFeaturingArtwork;
- (NSMutableSet *)installShotsFeaturingArtworkSet
{
    [self willAccessValueForKey:@"installShotsFeaturingArtwork"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"installShotsFeaturingArtwork"];
    [self didAccessValueForKey:@"installShotsFeaturingArtwork"];
    return result;
}

@dynamic locations;
- (NSMutableSet *)locationsSet
{
    [self willAccessValueForKey:@"locations"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"locations"];
    [self didAccessValueForKey:@"locations"];
    return result;
}

@dynamic mainImage;
@dynamic notes;
@dynamic partner;
@dynamic shows;
- (NSMutableSet *)showsSet
{
    [self willAccessValueForKey:@"shows"];
    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"shows"];
    [self didAccessValueForKey:@"shows"];
    return result;
}


@end

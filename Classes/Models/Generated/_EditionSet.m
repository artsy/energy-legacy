// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EditionSet.m instead.

#import "_EditionSet.h"

const struct EditionSetAttributes EditionSetAttributes = {
    .artistProofs = @"artistProofs",
    .availability = @"availability",
    .availableEditions = @"availableEditions",
    .backendPrice = @"backendPrice",
    .depth = @"depth",
    .diameter = @"diameter",
    .dimensionsCM = @"dimensionsCM",
    .dimensionsInches = @"dimensionsInches",
    .displayPrice = @"displayPrice",
    .duration = @"duration",
    .editionSize = @"editionSize",
    .editions = @"editions",
    .height = @"height",
    .isAvailableForSale = @"isAvailableForSale",
    .isPriceHidden = @"isPriceHidden",
    .prototypes = @"prototypes",
    .slug = @"slug",
    .width = @"width",
};

const struct EditionSetRelationships EditionSetRelationships = {
    .artwork = @"artwork",
};


@implementation EditionSetID
@end


@implementation _EditionSet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"EditionSet" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"EditionSet";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"EditionSet" inManagedObjectContext:moc_];
}

- (EditionSetID *)objectID
{
    return (EditionSetID *)[super objectID];
}

@dynamic artistProofs;
@dynamic availability;
@dynamic availableEditions;
@dynamic backendPrice;
@dynamic depth;
@dynamic diameter;
@dynamic dimensionsCM;
@dynamic dimensionsInches;
@dynamic displayPrice;
@dynamic duration;
@dynamic editionSize;
@dynamic editions;
@dynamic height;
@dynamic isAvailableForSale;
@dynamic isPriceHidden;
@dynamic prototypes;
@dynamic slug;
@dynamic width;

@dynamic artwork;

@end

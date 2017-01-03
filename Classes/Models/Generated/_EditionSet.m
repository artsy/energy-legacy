// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EditionSet.m instead.

#import "_EditionSet.h"


@implementation EditionSetID
@end


@implementation _EditionSet

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

    return keyPaths;
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

@dynamic prototypes;

@dynamic slug;

@dynamic width;

@dynamic artwork;

@end


@implementation EditionSetAttributes
+ (NSString *)artistProofs
{
    return @"artistProofs";
}
+ (NSString *)availability
{
    return @"availability";
}
+ (NSString *)availableEditions
{
    return @"availableEditions";
}
+ (NSString *)backendPrice
{
    return @"backendPrice";
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
+ (NSString *)duration
{
    return @"duration";
}
+ (NSString *)editionSize
{
    return @"editionSize";
}
+ (NSString *)editions
{
    return @"editions";
}
+ (NSString *)height
{
    return @"height";
}
+ (NSString *)isAvailableForSale
{
    return @"isAvailableForSale";
}
+ (NSString *)isPriceHidden
{
    return @"isPriceHidden";
}
+ (NSString *)prototypes
{
    return @"prototypes";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)width
{
    return @"width";
}
@end


@implementation EditionSetRelationships
+ (NSString *)artwork
{
    return @"artwork";
}
@end

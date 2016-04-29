// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.m instead.

#import "_Image.h"


@implementation ImageID
@end


@implementation _Image

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Image";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Image" inManagedObjectContext:moc_];
}

- (ImageID *)objectID
{
    return (ImageID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"aspectRatioValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"aspectRatio"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"isMainImageValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"isMainImage"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"maxTiledHeightValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"maxTiledHeight"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"maxTiledWidthValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"maxTiledWidth"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"originalHeightValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"originalHeight"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"originalWidthValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"originalWidth"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"positionValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"position"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"processingValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"processing"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"tileOverlapValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"tileOverlap"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"tileSizeValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"tileSize"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic aspectRatio;

- (float)aspectRatioValue
{
    NSNumber *result = [self aspectRatio];
    return [result floatValue];
}

- (void)setAspectRatioValue:(float)value_
{
    [self setAspectRatio:@(value_)];
}

- (float)primitiveAspectRatioValue
{
    NSNumber *result = [self primitiveAspectRatio];
    return [result floatValue];
}

- (void)setPrimitiveAspectRatioValue:(float)value_
{
    [self setPrimitiveAspectRatio:@(value_)];
}

@dynamic baseURL;

@dynamic isMainImage;

- (BOOL)isMainImageValue
{
    NSNumber *result = [self isMainImage];
    return [result boolValue];
}

- (void)setIsMainImageValue:(BOOL)value_
{
    [self setIsMainImage:@(value_)];
}

- (BOOL)primitiveIsMainImageValue
{
    NSNumber *result = [self primitiveIsMainImage];
    return [result boolValue];
}

- (void)setPrimitiveIsMainImageValue:(BOOL)value_
{
    [self setPrimitiveIsMainImage:@(value_)];
}

@dynamic maxTiledHeight;

- (int16_t)maxTiledHeightValue
{
    NSNumber *result = [self maxTiledHeight];
    return [result shortValue];
}

- (void)setMaxTiledHeightValue:(int16_t)value_
{
    [self setMaxTiledHeight:@(value_)];
}

- (int16_t)primitiveMaxTiledHeightValue
{
    NSNumber *result = [self primitiveMaxTiledHeight];
    return [result shortValue];
}

- (void)setPrimitiveMaxTiledHeightValue:(int16_t)value_
{
    [self setPrimitiveMaxTiledHeight:@(value_)];
}

@dynamic maxTiledWidth;

- (int16_t)maxTiledWidthValue
{
    NSNumber *result = [self maxTiledWidth];
    return [result shortValue];
}

- (void)setMaxTiledWidthValue:(int16_t)value_
{
    [self setMaxTiledWidth:@(value_)];
}

- (int16_t)primitiveMaxTiledWidthValue
{
    NSNumber *result = [self primitiveMaxTiledWidth];
    return [result shortValue];
}

- (void)setPrimitiveMaxTiledWidthValue:(int16_t)value_
{
    [self setPrimitiveMaxTiledWidth:@(value_)];
}

@dynamic originalHeight;

- (float)originalHeightValue
{
    NSNumber *result = [self originalHeight];
    return [result floatValue];
}

- (void)setOriginalHeightValue:(float)value_
{
    [self setOriginalHeight:@(value_)];
}

- (float)primitiveOriginalHeightValue
{
    NSNumber *result = [self primitiveOriginalHeight];
    return [result floatValue];
}

- (void)setPrimitiveOriginalHeightValue:(float)value_
{
    [self setPrimitiveOriginalHeight:@(value_)];
}

@dynamic originalWidth;

- (float)originalWidthValue
{
    NSNumber *result = [self originalWidth];
    return [result floatValue];
}

- (void)setOriginalWidthValue:(float)value_
{
    [self setOriginalWidth:@(value_)];
}

- (float)primitiveOriginalWidthValue
{
    NSNumber *result = [self primitiveOriginalWidth];
    return [result floatValue];
}

- (void)setPrimitiveOriginalWidthValue:(float)value_
{
    [self setPrimitiveOriginalWidth:@(value_)];
}

@dynamic position;

- (int16_t)positionValue
{
    NSNumber *result = [self position];
    return [result shortValue];
}

- (void)setPositionValue:(int16_t)value_
{
    [self setPosition:@(value_)];
}

- (int16_t)primitivePositionValue
{
    NSNumber *result = [self primitivePosition];
    return [result shortValue];
}

- (void)setPrimitivePositionValue:(int16_t)value_
{
    [self setPrimitivePosition:@(value_)];
}

@dynamic processing;

- (BOOL)processingValue
{
    NSNumber *result = [self processing];
    return [result boolValue];
}

- (void)setProcessingValue:(BOOL)value_
{
    [self setProcessing:@(value_)];
}

- (BOOL)primitiveProcessingValue
{
    NSNumber *result = [self primitiveProcessing];
    return [result boolValue];
}

- (void)setPrimitiveProcessingValue:(BOOL)value_
{
    [self setPrimitiveProcessing:@(value_)];
}

@dynamic slug;

@dynamic tileBaseUrl;

@dynamic tileFormat;

@dynamic tileOverlap;

- (int16_t)tileOverlapValue
{
    NSNumber *result = [self tileOverlap];
    return [result shortValue];
}

- (void)setTileOverlapValue:(int16_t)value_
{
    [self setTileOverlap:@(value_)];
}

- (int16_t)primitiveTileOverlapValue
{
    NSNumber *result = [self primitiveTileOverlap];
    return [result shortValue];
}

- (void)setPrimitiveTileOverlapValue:(int16_t)value_
{
    [self setPrimitiveTileOverlap:@(value_)];
}

@dynamic tileSize;

- (int16_t)tileSizeValue
{
    NSNumber *result = [self tileSize];
    return [result shortValue];
}

- (void)setTileSizeValue:(int16_t)value_
{
    [self setTileSize:@(value_)];
}

- (int16_t)primitiveTileSizeValue
{
    NSNumber *result = [self primitiveTileSize];
    return [result shortValue];
}

- (void)setPrimitiveTileSizeValue:(int16_t)value_
{
    [self setPrimitiveTileSize:@(value_)];
}

@dynamic artistsInImage;

@dynamic artwork;

@dynamic artworksInImage;

@dynamic coverForAlbum;

@dynamic coverForArtist;

@dynamic coverForShow;

@dynamic mainImageForArtwork;

@end


@implementation ImageAttributes
+ (NSString *)aspectRatio
{
    return @"aspectRatio";
}
+ (NSString *)baseURL
{
    return @"baseURL";
}
+ (NSString *)isMainImage
{
    return @"isMainImage";
}
+ (NSString *)maxTiledHeight
{
    return @"maxTiledHeight";
}
+ (NSString *)maxTiledWidth
{
    return @"maxTiledWidth";
}
+ (NSString *)originalHeight
{
    return @"originalHeight";
}
+ (NSString *)originalWidth
{
    return @"originalWidth";
}
+ (NSString *)position
{
    return @"position";
}
+ (NSString *)processing
{
    return @"processing";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)tileBaseUrl
{
    return @"tileBaseUrl";
}
+ (NSString *)tileFormat
{
    return @"tileFormat";
}
+ (NSString *)tileOverlap
{
    return @"tileOverlap";
}
+ (NSString *)tileSize
{
    return @"tileSize";
}
@end


@implementation ImageRelationships
+ (NSString *)artistsInImage
{
    return @"artistsInImage";
}
+ (NSString *)artwork
{
    return @"artwork";
}
+ (NSString *)artworksInImage
{
    return @"artworksInImage";
}
+ (NSString *)coverForAlbum
{
    return @"coverForAlbum";
}
+ (NSString *)coverForArtist
{
    return @"coverForArtist";
}
+ (NSString *)coverForShow
{
    return @"coverForShow";
}
+ (NSString *)mainImageForArtwork
{
    return @"mainImageForArtwork";
}
@end

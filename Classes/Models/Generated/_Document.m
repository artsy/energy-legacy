// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Document.m instead.

#import "_Document.h"


@implementation DocumentID
@end


@implementation _Document

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Document";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Document" inManagedObjectContext:moc_];
}

- (DocumentID *)objectID
{
    return (DocumentID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"hasFileValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"hasFile"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"sizeValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"size"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
    if ([key isEqualToString:@"versionValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"version"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic filename;

@dynamic hasFile;

- (BOOL)hasFileValue
{
    NSNumber *result = [self hasFile];
    return [result boolValue];
}

- (void)setHasFileValue:(BOOL)value_
{
    [self setHasFile:@(value_)];
}

- (BOOL)primitiveHasFileValue
{
    NSNumber *result = [self primitiveHasFile];
    return [result boolValue];
}

- (void)setPrimitiveHasFileValue:(BOOL)value_
{
    [self setPrimitiveHasFile:@(value_)];
}

@dynamic humanReadableSize;

@dynamic size;

- (int32_t)sizeValue
{
    NSNumber *result = [self size];
    return [result intValue];
}

- (void)setSizeValue:(int32_t)value_
{
    [self setSize:@(value_)];
}

- (int32_t)primitiveSizeValue
{
    NSNumber *result = [self primitiveSize];
    return [result intValue];
}

- (void)setPrimitiveSizeValue:(int32_t)value_
{
    [self setPrimitiveSize:@(value_)];
}

@dynamic slug;

@dynamic title;

@dynamic url;

@dynamic version;

- (int16_t)versionValue
{
    NSNumber *result = [self version];
    return [result shortValue];
}

- (void)setVersionValue:(int16_t)value_
{
    [self setVersion:@(value_)];
}

- (int16_t)primitiveVersionValue
{
    NSNumber *result = [self primitiveVersion];
    return [result shortValue];
}

- (void)setPrimitiveVersionValue:(int16_t)value_
{
    [self setPrimitiveVersion:@(value_)];
}

@dynamic album;

@dynamic artist;

@dynamic show;

@end


@implementation DocumentAttributes
+ (NSString *)filename
{
    return @"filename";
}
+ (NSString *)hasFile
{
    return @"hasFile";
}
+ (NSString *)humanReadableSize
{
    return @"humanReadableSize";
}
+ (NSString *)size
{
    return @"size";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)title
{
    return @"title";
}
+ (NSString *)url
{
    return @"url";
}
+ (NSString *)version
{
    return @"version";
}
@end


@implementation DocumentRelationships
+ (NSString *)album
{
    return @"album";
}
+ (NSString *)artist
{
    return @"artist";
}
+ (NSString *)show
{
    return @"show";
}
@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ArtistDocument.m instead.

#import "_ArtistDocument.h"


@implementation ArtistDocumentID
@end


@implementation _ArtistDocument

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"ArtistDocument" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"ArtistDocument";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"ArtistDocument" inManagedObjectContext:moc_];
}

- (ArtistDocumentID *)objectID
{
    return (ArtistDocumentID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@end

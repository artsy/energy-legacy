// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to InstallShotImage.m instead.

#import "_InstallShotImage.h"


@implementation InstallShotImageID
@end


@implementation _InstallShotImage

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"InstallShotImage" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"InstallShotImage";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"InstallShotImage" inManagedObjectContext:moc_];
}

- (InstallShotImageID *)objectID
{
    return (InstallShotImageID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@dynamic caption;

@dynamic showWithImageInInstallation;

@end


@implementation InstallShotImageAttributes
+ (NSString *)caption
{
    return @"caption";
}
@end


@implementation InstallShotImageRelationships
+ (NSString *)showWithImageInInstallation
{
    return @"showWithImageInInstallation";
}
@end

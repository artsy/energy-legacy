// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to InstallShotImage.m instead.

#import "_InstallShotImage.h"

const struct InstallShotImageAttributes InstallShotImageAttributes = {
    .caption = @"caption",
};

const struct InstallShotImageRelationships InstallShotImageRelationships = {
    .showWithImageInInstallation = @"showWithImageInInstallation",
};

const struct InstallShotImageUserInfo InstallShotImageUserInfo = {};


@implementation InstallShotImageID
@end


@implementation _InstallShotImage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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


@dynamic caption;


@dynamic showWithImageInInstallation;


@end

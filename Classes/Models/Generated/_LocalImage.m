// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LocalImage.m instead.

#import "_LocalImage.h"

const struct LocalImageUserInfo LocalImageUserInfo = {};


@implementation LocalImageID
@end


@implementation _LocalImage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"LocalImage" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"LocalImage";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"LocalImage" inManagedObjectContext:moc_];
}

- (LocalImageID *)objectID
{
    return (LocalImageID *)[super objectID];
}


@end

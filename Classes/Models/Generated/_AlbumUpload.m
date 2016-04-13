// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumUpload.m instead.

#import "_AlbumUpload.h"

const struct AlbumUploadAttributes AlbumUploadAttributes = {
    .createdAt = @"createdAt",
};

const struct AlbumUploadRelationships AlbumUploadRelationships = {
    .album = @"album",
};


@implementation AlbumUploadID
@end


@implementation _AlbumUpload

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"AlbumUpload" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"AlbumUpload";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"AlbumUpload" inManagedObjectContext:moc_];
}

- (AlbumUploadID *)objectID
{
    return (AlbumUploadID *)[super objectID];
}

@dynamic createdAt;

@dynamic album;

@end

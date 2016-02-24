// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.m instead.

#import "_Image.h"

const struct ImageAttributes ImageAttributes = {
    .aspectRatio = @"aspectRatio",
    .baseURL = @"baseURL",
    .isMainImage = @"isMainImage",
    .maxTiledHeight = @"maxTiledHeight",
    .maxTiledWidth = @"maxTiledWidth",
    .originalHeight = @"originalHeight",
    .originalWidth = @"originalWidth",
    .position = @"position",
    .processing = @"processing",
    .slug = @"slug",
    .tileBaseUrl = @"tileBaseUrl",
    .tileFormat = @"tileFormat",
    .tileOverlap = @"tileOverlap",
    .tileSize = @"tileSize",
};

const struct ImageRelationships ImageRelationships = {
    .artistsInImage = @"artistsInImage",
    .artwork = @"artwork",
    .artworksInImage = @"artworksInImage",
    .coverForAlbum = @"coverForAlbum",
    .coverForArtist = @"coverForArtist",
    .coverForShow = @"coverForShow",
    .mainImageForArtwork = @"mainImageForArtwork",
};

const struct ImageUserInfo ImageUserInfo = {};


@implementation ImageID
@end


@implementation _Image

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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


@dynamic aspectRatio;
@dynamic baseURL;
@dynamic isMainImage;
@dynamic maxTiledHeight;
@dynamic maxTiledWidth;
@dynamic originalHeight;
@dynamic originalWidth;
@dynamic position;
@dynamic processing;
@dynamic slug;
@dynamic tileBaseUrl;
@dynamic tileFormat;
@dynamic tileOverlap;
@dynamic tileSize;


@dynamic artistsInImage;
@dynamic artwork;
@dynamic artworksInImage;
@dynamic coverForAlbum;
@dynamic coverForArtist;
@dynamic coverForShow;
@dynamic mainImageForArtwork;


@end

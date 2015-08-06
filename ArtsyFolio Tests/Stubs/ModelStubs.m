//
// ModelStubs
// Created by orta on 14/01/2014.
//
//  Copyright (c) 2012 http://art.sy. All rights reserved.

#import "ModelStubs.h"
#import "Image.h"
#import "LocalImage.h"


@implementation Artwork (Stubs)

+ (Artwork *)stubbedArtworkWithImages:(BOOL)hasImages inContext:(NSManagedObjectContext *)context
{
    Artwork *artwork = [Artwork objectInContext:context];
    if (hasImages) {
        LocalImage *image = [LocalImage objectInContext:context];
        LocalImage *image2 = [LocalImage objectInContext:context];

        NSString *localImagePath = [[NSBundle bundleForClass:ARModelFactory.class] pathForResource:@"example-image" ofType:@"png"];
        image.imageFilePath = localImagePath;
        image2.imageFilePath = localImagePath;

        image.processing = @(NO);
        image2.processing = @(NO);

        artwork.images = [NSSet setWithArray:@[ image, image2 ]];
        artwork.mainImage = image;
    }
    return artwork;
}

@end


@implementation Artist (Stubs)

+ (Artist *)stubbedArtistWithPublishedArtworks:(BOOL)isPublished inContext:(NSManagedObjectContext *)context
{
    Artist *artist = [Artist objectInContext:context];
    Artwork *artwork = [Artwork stubbedArtworkWithImages:YES inContext:context];
    artwork.isPublished = @(isPublished);

    artist.artworks = [NSSet setWithArray:@[ artwork ]];
    artwork.artist = artist;

    return artist;
}

@end


@implementation Album (Stubs)

+ (Album *)stubbedAlbumWithPublishedArtworks:(BOOL)isPublished inContext:(NSManagedObjectContext *)context
{
    Album *album = [Album objectInContext:context];
    Artwork *artwork = [Artwork stubbedArtworkWithImages:YES inContext:context];
    artwork.isPublished = @(isPublished);

    album.artworks = [NSSet setWithArray:@[ artwork ]];

    return album;
}

@end

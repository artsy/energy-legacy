#import "ARArtworkContainerCoverDataSource.h"
#import "ModelStubs.h"

SpecBegin(ARArtworkContainerCoverDataSource);

__block NSManagedObjectContext *context;
__block ARArtworkContainerCoverDataSource *subject;
__block Album *container;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [[ARArtworkContainerCoverDataSource alloc] init];
    container = [Album stubbedAlbumWithPublishedArtworks:YES inContext:context];
});

it(@"gets the thumbnail path", ^{
    NSString *thumbnail = [subject gridThumbnailPath:@"size" container:container];
    expect([thumbnail hasSuffix:@"_size.jpg"]).to.beTruthy();
});

it(@"gets the thumbnail URL", ^{
    Artwork *artwork = container.artworks.anyObject;
    Image *image = [Image objectInContext:context];
    image.baseURL = @"https://baseurl.com/";
    artwork.mainImage = image;

    NSURL *thumbnail = [subject gridThumbnailURL:@"size" container:container];
    expect([thumbnail.absoluteString hasSuffix:@"size.jpg"]).to.beTruthy();
});

it(@"defaults the aspect ratio for an item to 1", ^{
    Artwork *artwork = container.artworks.anyObject;
    artwork.mainImage = nil;
    expect([subject aspectRatioForContainer:container]).to.equal(1);
});

it(@"gets the aspect ratio for an item", ^{
    Artwork *artwork = container.artworks.anyObject;
    artwork.mainImage.aspectRatio = @22;
    expect([subject aspectRatioForContainer:container]).to.equal(22);
});

SpecEnd


#import "ARTileArchiveDownloader.h"
#import "ARImageFormat.h"
#import "NSFileManager+SkipBackup.h"

@protocol Image <NSObject>
- (NSString *)slug;
- (NSURL *)urlForTileArchive;
- (BOOL)needsTiles;
@end


@interface ARTileArchiveDownloaderTests : XCTestCase
@end


@implementation ARTileArchiveDownloaderTests

- (void)stubFileDownload
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        const NSUInteger length = 128;
        void * bytes = malloc(length);
        NSData *data = [NSData dataWithBytes:bytes length:length];
        free(bytes); // make random data
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:@{ @"Content-Type": @"application/zip" }];
    }];
}

- (id)mockImageWithSlug:(NSString *)slug needsTiles:(BOOL)needsTiles
{
    id image = [OCMockObject mockForProtocol:@protocol(Image)];
    [[[image stub] andReturn:slug] slug];

    NSURL *url = [NSURL URLWithString:@"http://foo/bar.zip"];
    [[[image stub] andReturn:url] urlForTileArchive];
    [[[image stub] andReturnValue:OCMOCK_VALUE(needsTiles)] needsTiles];
    [[[image stub] andReturnValue:OCMOCK_VALUE(NO)] isKindOfClass:OCMOCK_ANY];

    return image;
}

- (void)testImagesWithTiles
{
    id image1 = [self mockImageWithSlug:@"image1" needsTiles:YES];
    id image2 = [self mockImageWithSlug:@"image2" needsTiles:YES];
    id image3 = [self mockImageWithSlug:@"image3" needsTiles:NO];
    id image4 = [self mockImageWithSlug:@"image4" needsTiles:YES];

    NSSet *images = [NSSet setWithObjects:image1, image2, image3, image4, nil];
    NSSet *slugs = [NSSet setWithObject:@"image4"];

    ARTileArchiveDownloader *downloader = [[ARTileArchiveDownloader alloc] init];
    NSSet *result = [downloader imagesWithTiles:images downloadedSlugs:slugs];

    expect(result.count).to.equal(2);
    expect(result).to.contain(image1);
    expect(result).to.contain(image2);
}

@end

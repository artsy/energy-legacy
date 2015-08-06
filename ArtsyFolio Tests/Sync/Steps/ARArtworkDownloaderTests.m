#import "ARArtworkDownloader.h"
#import "ARSynchronousOperationTree.h"
#import "ARSyncronousTreeProvider.h"

// required for Artwork.h
#import "Album.h"
#import "Artwork.h"

static NSString *const kARArtworkDownloaderTestsPartnerSlug = @"some-partner-slug";
static NSString *const kARArtworkDownloaderTestsArtworkSlug = @"some-artwork-slug";


SpecBegin(ARArtworkDownloader);


__block NSManagedObjectContext *context;
__block ARArtworkDownloader *downloader;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    downloader =  [[ARArtworkDownloader alloc] initWithContext:context deleter:nil];
});

afterEach(^{
    [OHHTTPStubs removeAllStubs];
});

pending(@"gets objects for objects", ^{
    NSArray *stubbedArtworks = @[@{}, @{}, @{}];
    [OHHTTPStubs stubRequestsMatchingPath:@"/api/v1/partner/some-partner-slug/artworks" returningJSONWithObject:stubbedArtworks];

    NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
    ARArtworkDownloader *downloader = [[ARArtworkDownloader alloc] initWithContext:context deleter:nil];

    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    DRBOperationTree *tree = [[ARSynchronousOperationTree alloc] initWithOperationQueue:operationQueue];
    tree.provider = downloader;

    __block NSArray *results;

    [downloader operationTree:tree objectsForObject:kARArtworkDownloaderTestsPartnerSlug completion:^(NSArray *objects) {
        results = objects;

        expect(results.count).will.equal(stubbedArtworks.count);
    }];
});

pending(@"gets an artwork from the operation for object", ^{
        [OHHTTPStubs stubRequestsMatchingPath:@"/api/v1/artwork/some-artwork-slug" returningJSONWithObject:@{ @"id" : kARArtworkDownloaderTestsArtworkSlug }];


        NSOperation *operation = [downloader operationTree:nil operationForObject:kARArtworkDownloaderTestsArtworkSlug
            continuation:^(id object, void (^completion)()) {

                expect(object).will.beKindOf(Artwork.class);

        } failure:nil];

        [operation start];
});

SpecEnd

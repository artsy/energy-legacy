#import "ARTileArchiveDownloader.h"
#import "ARTileArchive.h"
#import "ARFileUtils.h"
#import "ARSyncProgress.h"
#import "NSFileManager+SkipBackup.h"
#import "AFHTTPRequestOperation+ARFileDownload.h"
#import <Reachability/Reachability.h>


@interface ARTileArchiveDownloader ()
@property (nonatomic, strong) ARSyncProgress *progress;
@property (nonatomic, strong) NSMutableSet *slugs;
@end

static NSString *const kSlugsFileName = @"tile-slugs";
static NSString *const kSlugsFileExtension = @"data";


@implementation ARTileArchiveDownloader

- (instancetype)initWithProgress:(ARSyncProgress *)progress
{
    if ((self = [super init])) {
        _progress = progress;
        [self readSlugs];
    }
    return self;
}

- (NSString *)slugsPath
{
    return [ARFileUtils filePathWithFolder:nil filename:kSlugsFileName extension:kSlugsFileExtension];
}

- (void)readSlugs
{
    NSSet *slugs = [NSKeyedUnarchiver unarchiveObjectWithFile:self.slugsPath];
    if (slugs) {
        self.slugs = [slugs mutableCopy];
    } else {
        self.slugs = [NSMutableSet set];
    }
}

- (void)writeSlugs
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_slugs];
    [data writeToFile:[self slugsPath] atomically:YES];
}

/// Filter images to only images that need tiles (and haven't been downloaded)

- (NSSet *)imagesWithTiles:(NSSet *)images downloadedSlugs:(NSSet *)downloadedSlugs
{
    return [images objectsPassingTest:^BOOL(Image *image, BOOL *stop) {
        // // FIXME: should check isMainImage but it's null
        return ![downloadedSlugs member:image.slug] && image.needsTiles;
    }];
}

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(Artwork *)artwork completion:(void (^)(NSArray *))completion
{
    if ([Reachability reachabilityForLocalWiFi].isReachableViaWiFi) {
        NSSet *images = [self imagesWithTiles:artwork.images downloadedSlugs:_slugs];
        completion([images allObjects]);

    } else {
        ARSyncLog(@"Skipping downloading tiles due to not being on WIFI");
        completion(@[]);
    }
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(Image *)image
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSString *zipFileName = [NSString stringWithFormat:@"%@tiles.zip", image.slug];
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:zipFileName];

    AFHTTPRequestOperation *downloadOperation = [AFHTTPRequestOperation fileDownloadFromURL:image.urlForTileArchive toLocalPath:zipPath];
    @weakify(self);

    [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);

        unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:zipPath error:nil] fileSize];
        [self.progress downloadedNumBytes:size];

        [self.slugs addObject:image.slug];

        ARTileArchive *tileArchive = [[ARTileArchive alloc] init];
        tileArchive.image = image;
        tileArchive.path = zipPath;
        continuation(tileArchive, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return downloadOperation;
}

@end

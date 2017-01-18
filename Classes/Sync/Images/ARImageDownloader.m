#import "ARImageDownloader.h"
#import "ARImageFormat.h"
#import "ARSyncProgress.h"
#import "AFHTTPRequestOperation+ARFileDownload.h"
#import "NSFileManager+SkipBackup.h"


@interface ARImageDownloader ()
@property (nonatomic, strong) ARSyncProgress *progress;
@end


@implementation ARImageDownloader

- (instancetype)initWithProgress:(ARSyncProgress *)progress
{
    if ((self = [super init])) {
        _progress = progress;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    NSSet *images = nil;
    if ([object isKindOfClass:Artwork.class]) {
        images = [(Artwork *)object images];

    } else if ([object isKindOfClass:Image.class]) {
        images = [NSSet setWithObject:object];

    } else if ([object isKindOfClass:Show.class]) {
        images = [(Show *)object installationImages];
    }

    NSArray *imagesArray = [images allObjects];
    NSMutableArray *imageFormats = [NSMutableArray array];
    NSArray *formatsToDownload = [[imagesArray.firstObject class] imageFormatsToDownload];
    for (Image *image in imagesArray) {
        for (NSString *format in formatsToDownload) {
            [imageFormats addObject:[ARImageFormat imageFormatWithImage:image format:format]];
        }
    }
    completion(imageFormats);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(ARImageFormat *)imageFormat
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    AFHTTPRequestOperation *operation = [AFHTTPRequestOperation fileDownloadFromURL:imageFormat.URL toLocalPath:imageFormat.path];
    __weak typeof(self) weakSelf = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:imageFormat.path error:nil] fileSize];
        [weakSelf.progress downloadedNumBytes:size];

        if (imageFormat.isLarge) {
            NSDictionary *userInfo = @{ @"path" : imageFormat.path };
            [[NSNotificationCenter defaultCenter] postNotificationName:ARLargeImageDownloadCompleteNotification object:nil userInfo:userInfo];
        }

        continuation(imageFormat, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download image - %@", operation.request.URL);
        [[NSFileManager defaultManager] removeItemAtPath:imageFormat.path error:nil];

        failure();
    }];
    return operation;
}

@end

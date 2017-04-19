#import "ARDocumentFileDownloader.h"
#import "ARSyncProgress.h"
#import "AFHTTPRequestOperation+ARFileDownload.h"
#import "NSFileManager+SkipBackup.h"


@interface ARDocumentFileDownloader ()
@property (nonatomic, strong) ARSyncProgress *progress;
@end


@implementation ARDocumentFileDownloader

- (instancetype)initWithProgress:(ARSyncProgress *)progress
{
    if ((self = [super init])) {
        _progress = progress;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(Document *)document completion:(void (^)(NSArray *))completion
{
    completion(@[ document ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(Document *)document
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    // Let it pass through for thumbnail rendering
    if ([[NSFileManager defaultManager] fileExistsAtPath:document.filePath]) {
        return [NSBlockOperation blockOperationWithBlock:^{
            continuation(document, nil);
        }];
    }

    AFHTTPRequestOperation *downloadOperation = [AFHTTPRequestOperation authenticatedFileDownloadFromURL:document.fullURL toLocalPath:document.filePath];

    @weakify(self);
    [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        @strongify(self);
        unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:document.filePath error:nil] fileSize];

        [self.progress downloadedNumBytes:size];

        [document.managedObjectContext performBlockAndWait:^{
            [document setHasFile:@(YES)];
        }];

        continuation(document, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ARSyncLog(@"Download of Document file failed - %@", operation.request.URL.absoluteString);
        [[NSFileManager defaultManager] removeItemAtPath:document.filePath error:nil];

        failure();
    }];
    return downloadOperation;
}

@end

#import "AREstimateDownloader.h"
#import "ARRouter.h"
#import <AFNetworking/AFJSONRequestOperation.h>


@interface AREstimateDownloader ()
@property (nonatomic, strong) ARSyncProgress *progress;
@end


@implementation AREstimateDownloader

- (instancetype)initWithProgress:(ARSyncProgress *)progress
{
    if ((self = [super init])) {
        _progress = progress;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    completion(@[ object ]);
}

static BOOL AREstimateDownloaderEstimateIsValid(id total)
{
    return total && total != [NSNull null];
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(id)object
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSURLRequest *request = [ARRouter newPartnerSizeRequest:[Partner currentPartnerID]];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    @weakify(self);

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        @strongify(self);

        if (AREstimateDownloaderEstimateIsValid(JSON[@"total"])) {
            self.progress.numEstimatedBytes = [JSON[@"total"] unsignedLongLongValue];
            ARSyncLog(@"Server side estimate for download size is %@, ", JSON[@"total"]);
        }

        continuation(nil, nil);

    } failure:nil];
    return operation;
}

@end

#import "ARShowArtworksDownloader.h"
#import "ARRouter.h"
#import "ARPagingDownloaderOperation.h"


@implementation ARShowArtworksDownloader

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(Show *)show completion:(void (^)(NSArray *))completion
{
    completion(@[ show ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(Show *)show
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    ARPagingDownloaderOperation *downloaderOperation = [[ARPagingDownloaderOperation alloc] init];

    downloaderOperation.requestWithPage = ^NSURLRequest *(NSInteger page)
    {
        return [ARRouter newArtworksRequestForShowWithID:show.showSlug page:page partnerSlug:[Partner currentPartnerID]];
    };

    downloaderOperation.onCompletionWithIDs = ^(NSSet *slugs) {
        [show.managedObjectContext performBlockAndWait:^{
            show.artworkSlugs = slugs;
        }];

        continuation(show, nil);
    };

    downloaderOperation.failure = ^{
        failure();
    };

    return downloaderOperation;
}

@end

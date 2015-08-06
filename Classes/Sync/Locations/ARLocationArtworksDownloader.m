#import "ARLocationArtworksDownloader.h"
#import "ARRouter.h"
#import "ARPagingDownloaderOperation.h"


@implementation ARLocationArtworksDownloader

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(Show *)show completion:(void (^)(NSArray *))completion
{
    completion(@[ show ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(Location *)location
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    ARPagingDownloaderOperation *downloaderOperation = [[ARPagingDownloaderOperation alloc] init];

    downloaderOperation.requestWithPage = ^NSURLRequest *(NSInteger page)
    {
        return [ARRouter newPartnerLocationArtworksRequestWithPartnerID:[Partner currentPartnerID] locationID:location.slug page:page];
    };

    downloaderOperation.onCompletionWithIDs = ^(NSSet *slugs) {
        [location.managedObjectContext performBlockAndWait:^{
            location.artworkSlugs = slugs;
        }];

        continuation(location, nil);
    };

    downloaderOperation.failure = ^{
        failure();
    };

    return downloaderOperation;
}

@end

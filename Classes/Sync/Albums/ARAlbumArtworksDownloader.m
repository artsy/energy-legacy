//
// ARAlbumArtworksDownloader
// Created by orta on 3/26/14.
//
//  Copyright (c) 2014 http://artsy.net. All rights reserved.

#import "ARAlbumArtworksDownloader.h"
#import "ARPagingDownloaderOperation.h"
#import "ARRouter.h"


@implementation ARAlbumArtworksDownloader

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(Album *)album completion:(void (^)(NSArray *))completion
{
    completion(@[ album ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(Album *)album
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    // Ensure we keep a strong reference to album
    Album *currentAlbum = album;
    ARPagingDownloaderOperation *downloaderOperation = [[ARPagingDownloaderOperation alloc] init];

    downloaderOperation.requestWithPage = ^NSURLRequest *(NSInteger page)
    {
        return [ARRouter newArtworksRequestForPartner:[Partner currentPartnerID] album:currentAlbum.slug page:page];
    };

    downloaderOperation.onCompletionWithIDs = ^(NSSet *slugs) {
        currentAlbum.artworkSlugs = slugs;
        continuation(currentAlbum, nil);
    };

    downloaderOperation.failure = ^{
        failure();
    };

    return downloaderOperation;
}
@end

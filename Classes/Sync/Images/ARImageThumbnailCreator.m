#import "ARImageThumbnailCreator.h"
#import "ARThumbnailCreationOperation.h"
#import "ARImageFormat.h"
#import "ARThumbnail.h"


@implementation ARImageThumbnailCreator

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(ARImageFormat *)imageFormat completion:(void (^)(NSArray *))completion
{
    NSArray *thumbnails = nil;

    if (imageFormat.isLarge) {
        thumbnails = @[ [ARThumbnail thumbnailWithImage:imageFormat.image format:ARFeedImageSizeMediumKey],
                        [ARThumbnail thumbnailWithImage:imageFormat.image format:ARFeedImageSizeSquareKey] ];
    }

    completion(thumbnails);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(ARThumbnail *)thumbnail
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSOperation *operation = [ARThumbnailCreationOperation operationWithImage:thumbnail.image andSize:thumbnail.format];
    operation.completionBlock = ^{
        continuation(nil, nil);
    };
    return operation;
}

@end

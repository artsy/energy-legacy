#import <AFNetworking/AFHTTPRequestOperation.h>

#import "ARAlbumArtworksDownloader.h"
#import "ARRouter.h"
#import "AlbumDelete.h"
#import "ARAlbumEditOperation.h"
#import "ARAlbumDeleter.h"


@interface ARAlbumDeleter ()
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
@end


@implementation ARAlbumDeleter

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _context = context;

    return self;
}

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(NSString *)partnerID completion:(void (^)(NSArray *))completion
{
    completion([AlbumDelete findAllInContext:self.context]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(AlbumDelete *)albumDelete
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSString *partnerID = [Partner currentPartnerID];
    NSURLRequest *request = [ARRouter newPartnerAlbumDeleteRequestWithPartnerID:partnerID albumID:albumDelete.albumID];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [albumDelete deleteInContext:self.context];

        continuation(nil, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        /// If it was already deleted, remove the request
        if (operation.response.statusCode == 404) {
            [albumDelete deleteInContext:self.context];
        }

        failure();
    }];

    return operation;
}

@end

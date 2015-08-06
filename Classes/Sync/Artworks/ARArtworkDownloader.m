#import "ARArtworkDownloader.h"
#import "ARDeleter.h"
#import "ARRouter.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import "ARFeedTranslator.h"


@interface ARArtworkDownloader ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) ARDeleter *deleter;
@property (nonatomic, copy) NSArray *artworkIDs;
@end


@implementation ARArtworkDownloader

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter
{
    if ((self = [super init])) {
        _context = context;
        _deleter = deleter;
    }
    return self;
}

#pragma mark - AROperationProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *objects))completion
{
    NSURLRequest *request = [ARRouter newAllArtworkIDsRequestWithPartnerSlug:object];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    @weakify(self);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        self.artworkIDs = responseObject;
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];

    [node.operationQueue addOperation:operation];
}

- (NSOperation *)operationTree:(DRBOperationTree *)node operationForObject:(id)object
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSURLRequest *request = [ARRouter newArtworkRequestForArtworkWithID:object];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    @weakify(self);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);

        [ARFeedTranslator backgroundAddOrUpdateObjects:@[ responseObject ] withClass:Artwork.class inContext:self.context saving:NO completion:^(NSArray *objects) {
            Artwork *artwork = objects.firstObject;

            [self.deleter unmarkObjectForDeletion:artwork];
            [self.deleter unmarkObjectForDeletion:artwork.artist];

            for (id image in artwork.images) {
                [self.deleter unmarkObjectForDeletion:image];
            }

            // If it is the last artwork object, we can then let observers know
            // that all artworks are ready

            if ([object isEqual:self.artworkIDs.lastObject]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ARAllArtworksDownloadedNotification object:nil userInfo:nil];
            }
            
            continuation(artwork, nil);
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end

#import "ARShowCoverShotDownloader.h"
#import "ARRouter.h"
#import "ARFeedTranslator.h"
#import <AFNetworking/AFJSONRequestOperation.h>


@interface ARShowCoverShotDownloader ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) ARDeleter *deleter;
@end


@implementation ARShowCoverShotDownloader

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter
{
    if ((self = [super init])) {
        _context = context;
        _deleter = deleter;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(Show *)show completion:(void (^)(NSArray *))completion
{
    completion(@[ show ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(Show *)show
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSURLRequest *request = [ARRouter newCoverImageRequestForShowWithID:show.showSlug page:0];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *image = [responseObject firstObject];
        if (!image) {
            continuation(nil, nil);
            return;
        }

        [ARFeedTranslator backgroundAddOrUpdateObjects: @[image] withClass:Image.class inContext:self.context saving:NO completion:^(NSArray *objects) {

            [show.managedObjectContext performBlockAndWait:^{
                show.cover = objects.firstObject;
                [self.deleter unmarkObjectForDeletion:show.cover];
            }];
            continuation(show.cover, nil);
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];

    return operation;
}

@end

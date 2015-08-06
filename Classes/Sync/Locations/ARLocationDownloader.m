#import "ARLocationDownloader.h"
#import "ARDeleter.h"
#import "ARRouter.h"
#import "ARFeedTranslator.h"
#import <AFNetworking/AFJSONRequestOperation.h>


@interface ARLocationDownloader ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) ARDeleter *deleter;
@property (nonatomic, strong) NSString *partnerSlug;
@end


@implementation ARLocationDownloader

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter
{
    if ((self = [super init])) {
        _context = context;
        _deleter = deleter;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    self.partnerSlug = object;

    NSURLRequest *request = [ARRouter newLocationIDsRequestWithPartnerSlug:object];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];
    [node.operationQueue addOperation:operation];
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSString *)locationID
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSURLRequest *request = [ARRouter newPartnerLocationRequestWithPartnerID:self.partnerSlug locationID:locationID];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    __weak typeof(self) weakSelf = self;

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        [ARFeedTranslator backgroundAddOrUpdateObjects:@[ responseObject ] withClass:Location.class inContext:weakSelf.context saving:NO completion:^(NSArray *objects) {
            Location *location = objects.firstObject;
            [weakSelf.deleter unmarkObjectForDeletion:location];

            continuation(location, nil);
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end

#import "ARRouter.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import "ARIDMapperDownloader.h"
#import "ARSyncDeleter.h"
#import "ARFeedTranslator.h"


@interface ARIDMapperDownloader ()
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
@property (nonatomic, strong, readonly) ARSyncDeleter *deleter;
@end


@implementation ARIDMapperDownloader

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARSyncDeleter *)deleter
{
    if ((self = [super init])) {
        _context = context;
        _deleter = deleter;
    }
    return self;
}

- (Class)classForRenderedObjects
{
    [NSException raise:@"classForRenderedObjects should be subclassed" format:@""];
    return nil;
}

- (NSURLRequest *)urlRequestForIDsWithObject:(id)object
{
    [NSException raise:@"urlRequestForObjectIDs should be subclassed" format:@""];
    return nil;
}

- (NSURLRequest *)urlRequestForObjectWithID:(NSString *)objectID
{
    [NSException raise:@"urlRequestForObjectWithID: should be subclassed" format:@""];
    return nil;
}

- (void)performWorkWithDownloadObject:(id)object
{
    // Could do nothing.
}

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    NSURLRequest *request = [self urlRequestForIDsWithObject:object];

    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];

    [node.operationQueue addOperation:operation];
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSString *)objectID
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSURLRequest *request = [self urlRequestForObjectWithID:objectID];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    @weakify(self);

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);

        [ARFeedTranslator backgroundAddOrUpdateObjects:@[ responseObject ] withClass:self.classForRenderedObjects inContext:self.context saving:NO completion:^(NSArray *objects) {

            id object = objects.firstObject;
            [self.deleter unmarkObjectForDeletion:object];
            [self performWorkWithDownloadObject:object];

            continuation(object, nil);
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error on request: %@ - %@", operation.request.URL, error.localizedDescription);
        failure();
    }];

    return operation;
}

@end

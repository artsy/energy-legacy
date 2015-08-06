#import "ARUserMetadataDownloader.h"
#import "ARRouter.h"
#import "ARFeedTranslator.h"
#import <AFNetworking/AFJSONRequestOperation.h>


@interface ARUserMetadataDownloader ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end


@implementation ARUserMetadataDownloader

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) return nil;

    _context = context;

    return self;
}

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(NSString *)partnerSlug completion:(void (^)(NSArray *))completion
{
    completion(@[ partnerSlug ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSString *)partnerID
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSURLRequest *request = [ARRouter newUserInfoRequest];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    @weakify(self);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        @strongify(self);
        [ARFeedTranslator backgroundAddOrUpdateObjects:@[ responseObject ] withClass:User.class inContext:self.context saving:NO completion:^(NSArray *objects) {
            User *user = objects.firstObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:ARUserUpdatedNotification object:user];
            continuation(user, nil);
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end

#import "ARPartnerFullMetadataDownloader.h"
#import "ARRouter.h"
#import "ARFeedTranslator.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import "ARNetworkConstants.h"


@interface ARPartnerFullMetadataDownloader ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end


@implementation ARPartnerFullMetadataDownloader

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
    NSURLRequest *request = [ARRouter newPartnerFullInfoRequestWithID:partnerID];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    @weakify(self);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);

        [ARFeedTranslator backgroundAddOrUpdateObjects:@[ responseObject ] withClass:Partner.class inContext:self.context saving:NO completion:^(NSArray *objects) {
            Partner *partner = objects.firstObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:ARPartnerUpdatedNotification object:partner userInfo:@{ ARPartnerKey: partner }];

            continuation(partner.slug, nil);
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}


@end

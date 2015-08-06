#import "ARPartnerMetadataUploader.h"
#import "ARRouter.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>


@interface ARPartnerMetadataUploader ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end


@implementation ARPartnerMetadataUploader

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) return nil;

    _context = context;

    return self;
}

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(NSString *)partner completion:(void (^)(NSArray *))completion
{
    completion(@[ partner ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSString *)partnerID
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    /// Return a NOP if an admin
    if ([[User currentUserInContext:self.context] isAdmin]) {
        return [NSBlockOperation blockOperationWithBlock:^{
            continuation(nil, nil);
        }];
    }

    ISO8601DateFormatter *format = [[ISO8601DateFormatter alloc] init];
    NSDate *date = [NSDate date];

    NSURLRequest *request = [ARRouter newSetPartnerOptionForKey:@"last_folio_access" value:[format stringFromDate:date] partnerID:partnerID];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        continuation(nil, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}


@end

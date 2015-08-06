#import "ARSyncronousTreeProvider.h"


@implementation ARSyncronousTreeProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    completion(@[ object ?: [NSNull null] ]);
}
- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSString *)showID
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSOperation *operation = [[NSOperation alloc] init];
    operation.completionBlock = ^{
        continuation(nil, nil);
    };
    return operation;
}

@end

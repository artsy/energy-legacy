#import "ARStubbedSyncProvider.h"


@implementation ARStubbedSyncProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    self.sideEffect();
    completion(@[ @"" ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node operationForObject:(id)object continuation:(void (^)(id, void (^)()))continuation failure:(void (^)())failure
{
    return [NSBlockOperation blockOperationWithBlock:^{
        continuation(@"", nil);
    }];
}

@end

#import "ARStubbedSyncProvider.h"


@implementation ARStubbedSyncProvider

/// Runs sideEffect if it exists and returns an array containing an empty string from its completion block
- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    if (self.sideEffect) self.sideEffect();
    completion(@[ @"" ]);
}

/// Returns an NSBlockOperation that should continue the tree
- (NSOperation *)operationTree:(DRBOperationTree *)node operationForObject:(id)object continuation:(void (^)(id, void (^)()))continuation failure:(void (^)())failure
{
    return [NSBlockOperation blockOperationWithBlock:^{
        continuation(@"", nil);
    }];
}

@end

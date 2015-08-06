#import "ARSynchronousOperationTree.h"


@interface DRBOperationTree ()
@property (nonatomic, strong) NSMutableSet *children;
@end


@implementation ARSynchronousOperationTree

- (void)sendObject:(id)object completion:(void (^)())completion
{
    for (DRBOperationTree *child in self.children) {
        [child enqueueOperationsForObject:object completion:^{
        }];
    }

    completion();
}

- (void)enqueueOperationForObject:(id)object dispatchGroup:(dispatch_group_t)group
{
    NSOperation *operation = [self.provider operationTree:self operationForObject:object
        continuation:^(id result, void (^completion)()) {
            [self sendObject:result completion:^{
                if (completion) completion();
            }];
        }
        failure:^{
            [self enqueueOperationForObject:object dispatchGroup:group];
        }];

    [self.operationQueue addOperation:operation];
}

- (void)enqueueOperationsForObject:(id)object completion:(void (^)())completion
{
    [self.provider operationTree:self objectsForObject:object completion:^(NSArray *objects) {
        for (id object in objects) {
            [self enqueueOperationForObject:object dispatchGroup:nil];
        }
        completion();
    }];
}


@end

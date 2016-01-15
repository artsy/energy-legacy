#import <Foundation/Foundation.h>
#import <DRBOperationTree/DRBOperationTree.h>

/// A stubbed provider for a DRBOperationTree that has one empty block operation. If a sideEffect block is provided, it will execute it within its objectsForOperation method
@interface ARStubbedSyncProvider : NSObject <DRBOperationProvider>

@property (nonatomic, copy) void (^sideEffect)(void);

@end

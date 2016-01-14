#import <Foundation/Foundation.h>
#import <DRBOperationTree/DRBOperationTree.h>


@interface ARStubbedSyncProvider : NSObject <DRBOperationProvider>

@property (nonatomic, copy) void (^sideEffect)(void);

@end

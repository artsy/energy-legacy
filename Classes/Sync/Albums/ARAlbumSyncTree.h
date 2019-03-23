#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ARAlbumSyncTree : NSObject

+ (void)appendAlbumOperationTree:(ARSyncConfig *)config toNode:(DRBOperationTree *)rootNode operations:(NSMutableArray *)operationQueues;

@end

NS_ASSUME_NONNULL_END

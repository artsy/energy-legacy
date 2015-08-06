#import <DRBOperationTree/DRBOperationTree.h>
#import "ARSyncProgress.h"


@interface AREstimateDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithProgress:(ARSyncProgress *)progress;

@end

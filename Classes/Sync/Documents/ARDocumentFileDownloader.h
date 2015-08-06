#import <DRBOperationTree/DRBOperationTree.h>

@class ARSyncProgress;


@interface ARDocumentFileDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithProgress:(ARSyncProgress *)progress;

@end

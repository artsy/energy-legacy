#import <DRBOperationTree/DRBOperationTree.h>

@class ARSyncProgress;

/**
 `ARImageDownloader` is an ARSyncNode that receives `Image` objects and downloads all formats for the image.

 It sends the paths to the downloaded files to any child nodes for further processing.
 */
@interface ARImageDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithProgress:(ARSyncProgress *)progress;

@end

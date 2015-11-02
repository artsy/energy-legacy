#import <DRBOperationTree/DRBOperationTree.h>

@class ARSyncDeleter;


@interface ARArtworkDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARSyncDeleter *)deleter;

@end

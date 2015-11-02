#import <DRBOperationTree/DRBOperationTree.h>

@class ARSyncDeleter;


@interface ARLocationDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARSyncDeleter *)deleter;

@end

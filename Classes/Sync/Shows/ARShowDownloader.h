#import <DRBOperationTree/DRBOperationTree.h>
@class ARSyncDeleter;


@interface ARShowDownloader : NSObject <DRBOperationProvider>
- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARSyncDeleter *)deleter;
@end

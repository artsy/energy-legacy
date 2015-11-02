#import <DRBOperationTree/DRBOperationTree.h>
#import "ARSyncDeleter.h"


@interface ARShowCoverShotDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARSyncDeleter *)deleter;

@end

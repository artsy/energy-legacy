#import <DRBOperationTree/DRBOperationTree.h>
#import "ARDeleter.h"


@interface ARShowCoverShotDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter;

@end

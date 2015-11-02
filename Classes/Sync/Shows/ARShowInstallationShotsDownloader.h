#import <DRBOperationTree/DRBOperationTree.h>
#import "ARSyncDeleter.h"


@interface ARShowInstallationShotsDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARSyncDeleter *)deleter;

@end

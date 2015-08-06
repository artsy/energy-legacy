#import <DRBOperationTree/DRBOperationTree.h>
#import "ARDeleter.h"


@interface ARShowInstallationShotsDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter;

@end

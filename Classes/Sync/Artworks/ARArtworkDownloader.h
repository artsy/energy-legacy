#import <DRBOperationTree/DRBOperationTree.h>

@class ARDeleter;


@interface ARArtworkDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter;

@end

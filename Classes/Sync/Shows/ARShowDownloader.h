#import <DRBOperationTree/DRBOperationTree.h>
@class ARDeleter;


@interface ARShowDownloader : NSObject <DRBOperationProvider>
- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter;
@end

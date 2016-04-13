#import <DRBOperationTree/DRBOperationTree.h>


@interface ARAlbumChangeUploader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end

#import <DRBOperationTree/DRBOperationTree.h>

@interface ARAlbumUploader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end


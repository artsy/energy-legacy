#import <DRBOperationTree/DRBOperationTree.h>


@interface ARAlbumDeleter : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end

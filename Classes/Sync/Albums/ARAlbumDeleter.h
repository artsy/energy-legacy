#import <DRBOperationTree/DRBOperationTree.h>

/// Handles remotely removing an album in gravity
///
@interface ARAlbumDeleter : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end

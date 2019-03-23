#import <DRBOperationTree/DRBOperationTree.h>

/// Handles remotely removing an album in gravity
///
// Thing to note: This tree is a bit of a weird edge case. It operates
// a little bit more like a queue then all of the others. This is because
// we want edits to happen first, then album deletions, then album downloads
//
// So, to indicate that all operations are done, it will emit a single NSNull
// down the tree which will get picked up by the ARAlbumDownloader
//
@interface ARAlbumDeleter : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end

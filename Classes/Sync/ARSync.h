#import "ARSyncProgress.h"

@class ARSync, ARDeleter, ARTileArchiveDownloader;


@protocol ARSyncDelegate <NSObject>

- (void)syncDidFinish:(ARSync *)sync;

@end

/// An API for registering interest with a
/// sync on before and after callbacks.

@protocol ARSyncPlugin <ARSyncDelegate>

- (void)syncDidStart:(ARSync *)sync;

@end


@interface ARSync : NSObject

/// Start the sync operation tree
- (void)sync;

/// Cancel all sync operations
- (void)cancel;

/// Pause when offline
- (void)setPaused:(BOOL)paused;

/// Give a rough estimate for download size
- (unsigned long long)estimatedNumBytesToDownload;

/// Save the private MOC
- (void)save;

@property (readwrite, nonatomic, weak) id<ARSyncDelegate> delegate;
@property (readwrite, nonatomic, strong) ARSyncProgress *progress;

@property (readonly, nonatomic, getter=isSyncing) BOOL syncing;
@property (readonly, nonatomic, getter=applicationHasBackgrounded) BOOL applicationHasGoneIntoTheBackground;

/// Move these to a sync config object

@property (readonly, nonatomic, strong) NSUserDefaults *defaults;
@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end

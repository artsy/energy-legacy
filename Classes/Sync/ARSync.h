#import "ARSyncProgress.h"
#import "ARSyncConfig.h"
#import "ARSync.h"

@class ARSync;

@protocol ARSyncDelegate <NSObject>
@optional
- (void)syncDidFinish:(ARSync *)sync;
@end

/// An API for registering interest with a
/// sync on before and after callbacks.

@protocol ARSyncPlugin <ARSyncDelegate>
@optional
- (void)syncDidStart:(ARSync *)sync;

@end

#import "ARSyncDeleter.h"


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

/// Persists albums outside Core Data stack.
- (void)persistAlbums;

@property (readwrite, nonatomic, weak) id<ARSyncDelegate> delegate;
@property (readwrite, nonatomic, strong) ARSyncProgress *progress;
@property (readwrite, nonatomic, strong) ARSyncConfig *config;

@property (readonly, nonatomic, getter=isSyncing) BOOL syncing;

@end

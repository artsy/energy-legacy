#import "ARSyncProgress.h"

@class ARSync, ARDeleter, ARTileArchiveDownloader;

@protocol ARSyncDelegate <NSObject>

- (void)syncDidFinish:(ARSync *)sync;

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

@end

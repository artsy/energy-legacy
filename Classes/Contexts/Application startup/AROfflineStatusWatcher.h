@class ARSync;

/// Listens for Reachabililty changes and pauses the sync
@interface AROfflineStatusWatcher : NSObject

- (instancetype)initWithSync:(ARSync *)sync;

@end

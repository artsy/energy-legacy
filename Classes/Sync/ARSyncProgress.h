@class ARSyncProgress;

@protocol ARSyncProgressDelegate <NSObject>
- (void)syncDidProgress:(ARSyncProgress *)progress;
@end

/// The progress keeps a running track of how far along in the
/// downloading process we are. It does a great job of keeping track
/// but in general, our estimates of how much to download need work.


@interface ARSyncProgress : NSObject

- (void)start;

- (void)downloadedNumBytes:(unsigned long long)numBytes;

- (NSTimeInterval)estimatedTimeRemaining;

@property (readwrite, nonatomic, weak) id<ARSyncProgressDelegate> delegate;

@property (readwrite, nonatomic, assign) unsigned long long numEstimatedBytes;
@property (readonly, nonatomic, assign) CGFloat percentDone;
@property (readonly, nonatomic, strong) NSDate *startDate;

@end

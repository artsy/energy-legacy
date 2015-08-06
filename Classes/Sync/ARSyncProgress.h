@class ARSyncProgress;

@protocol ARSyncProgressDelegate <NSObject>
- (void)syncDidProgress:(ARSyncProgress *)progress;
@end


@interface ARSyncProgress : NSObject

- (void)start;

- (void)downloadedNumBytes:(unsigned long long)numBytes;

- (NSTimeInterval)estimatedTimeRemaining;

@property (readwrite, nonatomic, weak) id<ARSyncProgressDelegate> delegate;

@property (readwrite, nonatomic, assign) unsigned long long numEstimatedBytes;
@property (readonly, nonatomic, assign) CGFloat percentDone;
@property (readonly, nonatomic, strong) NSDate *startDate;

@end

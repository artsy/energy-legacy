#import "ARSync.h"

@class ARSyncStatusViewModel;

typedef NS_ENUM(NSInteger, ARSyncStatus) {
    ARSyncStatusUpToDate,
    ARSyncStatusRecommendSync,
    ARSyncStatusOffline,
    ARSyncStatusSyncing,
};

@interface ARSyncStatusViewModel : NSObject <ARSyncDelegate, ARSyncProgressDelegate>

@property (nonatomic, strong) ARSync *sync;
@property (nonatomic, assign) BOOL isSyncing;
@property (nonatomic, assign) NSTimeInterval timeRemainingInSync;

- (instancetype)initWithSync:(ARSync *)sync;

- (void)startSync;

- (ARSyncStatus)syncStatus;

- (NSString *)titleTextForStatus:(ARSyncStatus)status;
- (NSString *)subtitleTextForStatus:(ARSyncStatus)status;
- (NSString *)syncButtonTitleForStatus:(ARSyncStatus)status;
- (NSString *)syncInProgressTitle:(NSTimeInterval)estimatedTimeRemaining;

@end

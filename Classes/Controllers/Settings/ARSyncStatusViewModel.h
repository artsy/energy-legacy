#import "ARSync.h"
#import "ARNetworkQualityIndicator.h"


@class ARSyncStatusViewModel;

typedef NS_ENUM(NSInteger, ARSyncStatus) {
    ARSyncStatusSyncing,
    ARSyncStatusUpToDate,
    ARSyncStatusRecommendSync,
    ARSyncStatusOffline,
};

typedef NS_ENUM(NSInteger, ARSyncImageNotification) {
    ARSyncImageNotificationUpToDate,
    ARSyncImageNotificationRecommendSync,
    ARSyncImageNotificationNone,
};


@interface ARSyncStatusViewModel : NSObject <ARSyncDelegate, ARSyncProgressDelegate>

@property (nonatomic, assign) NSTimeInterval timeRemainingInSync;
@property (nonatomic, assign) CGFloat currentSyncPercentDone;

@property (nonatomic, assign) BOOL isOffline;
@property (nonatomic, assign) ARNetworkQuality networkQuality;
@property (nonatomic, strong) ARNetworkQualityIndicator *qualityIndicator;

- (instancetype)initWithSync:(ARSync *)sync context:(NSManagedObjectContext *)context;

- (void)startSync;

- (BOOL)isActivelySyncing;

- (UIImage *)wifiStatusImage;
- (UIColor *)statusLabelTextColor;

- (NSString *)titleText;
- (NSString *)subtitleText;
- (NSString *)syncInProgressTitle;
- (NSString *)statusLabelText;

- (BOOL)shouldShowSyncButton;
- (BOOL)shouldEnableSyncButton;
- (NSString *)syncButtonTitle;
- (UIColor *)syncButtonColor;

- (CGFloat)syncActivityViewAlpha;

- (ARSyncImageNotification)currentSyncImageNotification;

/// Returns the number of syncs logged on device
- (NSInteger)syncLogCount;

/// Returns an array of formatted date strings for all recorded syncs
- (NSArray<NSString *> *)previousSyncDateStrings;

@end

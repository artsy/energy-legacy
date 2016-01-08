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


@property (nonatomic, strong) ARNetworkQualityIndicator *qualityIndicator;
@property (nonatomic, assign) ARNetworkQuality networkQuality;
@property (nonatomic, assign) CGFloat currentSyncPercentDone;
@property (nonatomic, assign) NSTimeInterval timeRemainingInSync;

- (instancetype)initWithSync:(ARSync *)sync context:(NSManagedObjectContext *)context;

/// Initiates a sync
- (void)startSync;

/// Can be checked to see if a sync is actively taking place; will be OFF if there's no network connection
- (BOOL)isActivelySyncing;

/// Can be used to ensure the sync button isn't pressed when offline
- (BOOL)shouldEnableSyncButton;

/// Returns a WiFi icon that corresponds to the current network status
- (UIImage *)wifiStatusImage;

/// Text color that corresponds to current network status
- (UIColor *)statusLabelTextColor;

/// Returns a string that describes either the network status or the time remaining in an active sync
- (NSString *)statusLabelText;

/// Titles for the sync button states; should be used during button setup
- (NSString *)syncButtonNormalTitle;
- (NSString *)SyncButtonDisabledTitle;

/// Returns the number of syncs logged on device
- (NSInteger)syncLogCount;

/// Returns an array of formatted date strings for all recorded syncs
- (NSArray<NSString *> *)previousSyncDateStrings;


/// Methods & property below are deprecated; will be removed with old settings

@property (nonatomic, assign) BOOL isOffline;

- (NSString *)titleText;
- (NSString *)subtitleText;
- (BOOL)shouldShowSyncButton;
- (NSString *)syncButtonTitle;
- (UIColor *)syncButtonColor;
- (CGFloat)syncActivityViewAlpha;

- (ARSyncImageNotification)currentSyncImageNotification;

@end

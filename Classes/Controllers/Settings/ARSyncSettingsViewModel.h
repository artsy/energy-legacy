#import "ARSync.h"
#import "ARNetworkQualityIndicator.h"

@protocol ARSyncSettingsDelegate <NSObject>

- (void)didUpdateNetworkQuality;
- (void)didUpdateSyncPercent;
- (void)syncDidFinish;

@end

@class ARSyncSettingsViewModel;


@interface ARSyncSettingsViewModel : NSObject <ARSyncDelegate, ARSyncProgressDelegate>


@property (nonatomic, strong) ARNetworkQualityIndicator *qualityIndicator;
@property (nonatomic, assign) ARNetworkQuality networkQuality;
@property (nonatomic, assign) CGFloat currentSyncPercentDone;
@property (nonatomic, assign) NSTimeInterval timeRemainingInSync;

@property (weak) id<ARSyncSettingsDelegate> settingsDelegate;

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

/// Color for sync button; will be either black or purple
- (UIColor *)syncButtonColor;

/// Titles for the sync button states
- (NSString *)syncButtonEnabledTitle;
- (NSString *)syncButtonDisabledTitle;

/// Returns the number of syncs logged on device
- (NSInteger)syncLogCount;

/// Returns an array of formatted date strings for all recorded syncs
- (NSArray<NSString *> *)previousSyncDateStrings;

@end

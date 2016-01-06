
#import "ARSyncStatusViewModel.h"
#import "NSString+TimeInterval.h"
#import "Reachability+ConnectionExists.h"
#import "NSDate+Presentation.h"
#import "SyncLog.h"
#import "AROptions.h"


@interface ARSyncStatusViewModel ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) ARSync *sync;
@end


@implementation ARSyncStatusViewModel

- (instancetype)initWithSync:(ARSync *)sync context:(NSManagedObjectContext *)context
{
    return [self initWithSync:sync context:context qualityIndicator:[[ARNetworkQualityIndicator alloc] init]];
}

- (instancetype)initWithSync:(ARSync *)sync context:(NSManagedObjectContext *)context qualityIndicator:(ARNetworkQualityIndicator *)qualityIndicator
{
    self = [super init];
    if (!self) return nil;

    self.context = context;
    self.sync = sync;
    self.sync.delegate = self;
    self.sync.progress.delegate = self;

    self.qualityIndicator = qualityIndicator;
    [self.qualityIndicator beginObservingNetworkQuality:^(ARNetworkQuality quality) {
        self.networkQuality = quality;
    }];

    return self;
}

- (BOOL)isActivelySyncing
{
    return self.networkQuality != ARNetworkQualityOffline && self.sync.isSyncing;
}

#pragma mark -
#pragma mark sync methods

- (void)startSync
{
    self.currentSyncPercentDone = 0;
    [self.sync sync];
}

- (void)syncDidProgress:(ARSyncProgress *)progress
{
    self.timeRemainingInSync = progress.estimatedTimeRemaining;
    self.currentSyncPercentDone = progress.percentDone;
}

- (void)syncDidFinish:(ARSync *)sync
{
    self.currentSyncPercentDone = 1;
    self.timeRemainingInSync = 0;
}

- (ARSyncStatus)syncStatus
{
    if (self.isOffline) {
        return ARSyncStatusOffline;
    } else if (self.sync.isSyncing) {
        return ARSyncStatusSyncing;
    } else if ([self.defaults boolForKey:ARRecommendSync]) {
        return ARSyncStatusRecommendSync;
    } else {
        return ARSyncStatusUpToDate;
    }
}

- (UIImage *)wifiStatusImage
{
    switch (self.networkQuality) {
        case ARNetworkQualityGood:
            return [UIImage imageNamed:@"wifi-strong"];
            break;
        case ARNetworkQualityOK:
        case ARNetworkQualitySlow:
            return [UIImage imageNamed:@"wifi-weak"];
        case ARNetworkQualityOffline:
            return [UIImage imageNamed:@"wifi-off"];
    }
}

- (NSString *)statusLabelText
{
    if (self.isActivelySyncing) return self.syncInProgressTitle;

    switch (self.networkQuality) {
        case ARNetworkQualityGood:
            return NSLocalizedString(@"Your WiFi signal is strong.", @"Text for strong wifi signal");
            break;
        case ARNetworkQualityOK:
        case ARNetworkQualitySlow:
            return NSLocalizedString(@"Your WiFi signal is weak. We recommend seeking a stronger signal for the fastest sync.", @"Suggestion to find better wifi before syncing");
            break;
        case ARNetworkQualityOffline:
            return NSLocalizedString(@"You are not connected to WiFi right now.", @"Text to tell the user they aren't connected to WiFi");
            break;
    }
}

- (UIColor *)statusLabelTextColor
{
    if (!self.isActivelySyncing && self.networkQuality == ARNetworkQualityGood) return UIColor.artsyHeavyGreen;

    return UIColor.blackColor;
}

#pragma mark -
#pragma mark sync button

- (BOOL)shouldEnableSyncButton
{
    if (![self.defaults boolForKey:AROptionsUseLabSettings]) {
        return !(self.syncStatus == ARSyncStatusOffline); /// Deprecated; will be removed once old settings are totally replaced

    } else {
        return !(self.networkQuality == ARNetworkQualityOffline);
    }
}

- (BOOL)shouldShowSyncButton
{
    return !(self.syncStatus == ARSyncStatusSyncing);
}

- (NSString *)syncButtonTitle
{
    if (self.syncStatus == ARSyncStatusRecommendSync) {
        return NSLocalizedString(@"Sync New Content", @"Sync button text when we're recommending a sync");
    } else if ([self.defaults boolForKey:AROptionsUseLabSettings] && self.syncStatus == ARSyncStatusOffline) {
        return NSLocalizedString(@"Sync Unavailable", @"Sync button text when there's no network connection");
    }

    return NSLocalizedString(@"Sync Content", @"Sync button text after syncing completed");
}

- (UIColor *)syncButtonColor
{
    if (self.syncStatus == ARSyncStatusRecommendSync) return [UIColor artsyPurple];
    return [UIColor artsyHeavyGrey];
}

#pragma mark -
#pragma mark sync logs

- (NSArray<NSString *> *)previousSyncDateStrings;
{
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"dateStarted" ascending:NO];
    return [[self.syncLogs sortedArrayUsingDescriptors:@[ sortByDate ]] map:^id(SyncLog *log) {
        return log.dateStarted.formattedString;
    }];
}

- (NSInteger)syncLogCount
{
    return [SyncLog countInContext:self.context error:nil];
}

- (NSArray *)syncLogs
{
    return [SyncLog findAllSortedBy:@"dateStarted" ascending:YES inContext:self.context];
}

#pragma mark -
#pragma mark deprecated methods

- (CGFloat)syncActivityViewAlpha
{
    if (self.syncStatus == ARSyncStatusSyncing) return 1;
    return 0;
}

- (ARSyncImageNotification)currentSyncImageNotification
{
    if (self.syncStatus == ARSyncStatusUpToDate)
        return ARSyncImageNotificationUpToDate;
    else if (self.syncStatus == ARSyncStatusRecommendSync)
        return ARSyncImageNotificationRecommendSync;
    else
        return ARSyncImageNotificationNone;
}

- (NSString *)titleText
{
    switch (self.syncStatus) {
        case ARSyncStatusOffline:
            return [self lastSyncedString];

        case ARSyncStatusRecommendSync:
            return NSLocalizedString(@"New Content in CMS", @"New content in CMS label");

        case ARSyncStatusSyncing:
            return NSLocalizedString(@"Sync in progress...", @"Sync is in progress string with ellipses");

        case ARSyncStatusUpToDate:
            return NSLocalizedString(@"Content is up to date", @"All content up-to-date string");
    }
}

- (NSString *)subtitleText
{
    switch (self.syncStatus) {
        case ARSyncStatusOffline:
            return NSLocalizedString(@"Syncing is not available offline", @"Label that tells user they cannot sync without a network connection");

        case ARSyncStatusRecommendSync:
            return [self lastSyncedString];

        case ARSyncStatusSyncing:
            return @"";

        case ARSyncStatusUpToDate:
            return [self lastSyncedString];
    }
}

- (NSString *)syncInProgressTitle
{
    NSTimeInterval remaining = self.sync.progress.estimatedTimeRemaining;

    if (self.isActivelySyncing && remaining > 0) {
        NSTimeInterval oneDay = 86400;
        NSString *timeLeft = [NSString cappedStringForTimeInterval:remaining cap:oneDay];

        if ([timeLeft containsString:@"less than"] || [timeLeft containsString:@"about"]) {
            timeLeft = [timeLeft stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[timeLeft substringToIndex:1] capitalizedString]];
        } else {
            timeLeft = [NSString stringWithFormat:@"About %@", timeLeft.lowercaseString];
        }

        return [@[ @"Syncing in progress.", timeLeft, @"remaining..." ] componentsJoinedByString:@" "];
    }

    return @"Loading...";
}

- (NSString *)lastSyncedString
{
    NSDate *lastSynced = [self.defaults objectForKey:ARLastSyncDate];
    if (lastSynced) {
        NSString *lastSyncedFormat = NSLocalizedString(@"Last synced %@", @"Text for saying the last time you synced was %@");
        return [NSString stringWithFormat:lastSyncedFormat, [lastSynced formattedString]];
    }
    return @"";
}

- (void)dealloc
{
    [self.qualityIndicator stopObservingNetworkQuality];
}

#pragma mark -
#pragma mark dependency injection

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end

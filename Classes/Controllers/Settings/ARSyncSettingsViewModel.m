
#import "ARSyncSettingsViewModel.h"
#import "NSString+TimeInterval.h"
#import "Reachability+ConnectionExists.h"
#import "NSDate+Presentation.h"
#import "SyncLog.h"
#import "AROptions.h"


@interface ARSyncSettingsViewModel ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) ARSync *sync;
@end


@implementation ARSyncSettingsViewModel

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

    self.networkQuality = ARNetworkQualityGood;
    self.qualityIndicator = qualityIndicator;
    [self.qualityIndicator beginObservingNetworkQuality:^(ARNetworkQuality quality) {
        BOOL changed = self.networkQuality != quality;
        self.networkQuality = quality;
        if (changed) {
            [self.settingsDelegate didUpdateNetworkQuality];
        }
    }];

    return self;
}

#pragma mark -
#pragma mark sync actions & sync delegate methods

- (void)startSync
{
    self.currentSyncPercentDone = 0;
    [self.sync sync];
}

- (BOOL)isActivelySyncing
{
    return (self.networkQuality != ARNetworkQualityOffline) && self.sync.isSyncing;
}

- (BOOL)shouldEnableSyncButton
{
    return !(self.networkQuality == ARNetworkQualityOffline);
}

- (BOOL)recommendSync
{
    return (self.networkQuality != ARNetworkQualityOffline) && [self.defaults boolForKey:ARRecommendSync];
}

- (void)syncDidProgress:(ARSyncProgress *)progress
{
    self.timeRemainingInSync = progress.estimatedTimeRemaining;
    self.currentSyncPercentDone = progress.percentDone;
    [self.settingsDelegate didUpdateSyncPercent];
}

- (void)syncDidFinish:(ARSync *)sync
{
    self.currentSyncPercentDone = 1;
    self.timeRemainingInSync = 0;
    [self.settingsDelegate syncDidFinish];
}

#pragma mark -
#pragma mark aesthetic elements

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

- (UIColor *)statusLabelTextColor
{
    if (!self.isActivelySyncing && self.networkQuality == ARNetworkQualityGood) return UIColor.artsyHeavyGreen;

    return UIColor.blackColor;
}

- (UIColor *)syncButtonColor
{
    if ((self.networkQuality != ARNetworkQualityOffline) && [self.defaults boolForKey:ARRecommendSync]) return [UIColor artsyPurpleRegular];

    return UIColor.blackColor;
}

#pragma mark -
#pragma mark text methods

- (NSString *)statusLabelText
{
    if (self.isActivelySyncing) return self.syncInProgressTitle;

    switch (self.networkQuality) {
        case ARNetworkQualityGood:
            return NSLocalizedString(@"Your WiFi signal is strong.", @"Text for strong wifi signal");
            break;
        case ARNetworkQualityOK:
        case ARNetworkQualitySlow:
            return NSLocalizedString(@"Your WiFi signal is weak. We recommend seeking a stronger signal for a fast sync.", @"Suggestion to find better wifi before syncing");
            break;
        case ARNetworkQualityOffline:
            return NSLocalizedString(@"You are not connected to WiFi. Please establish a strong WiFi connection to start syncing.", @"Text to tell the user they aren't connected to WiFi");
            break;
    }
}

- (NSString *)syncButtonDisabledTitle
{
    return NSLocalizedString(@"Sync Unavailable", @"Sync button text when there's no network connection");
}

- (NSString *)syncButtonEnabledTitle
{
    if (self.recommendSync) {
        return NSLocalizedString(@"Sync New Content", @"Sync button text when recommending a sync");
    } else {
        return NSLocalizedString(@"Sync Content", @"Sync button text after syncing completed");
    }
}

- (NSString *)syncInProgressTitle
{
    NSTimeInterval remaining = self.timeRemainingInSync;

    if (self.isActivelySyncing && remaining > 0) {
        NSTimeInterval oneDay = 86400;
        NSString *timeLeft = [NSString cappedStringForTimeInterval:remaining cap:oneDay];

        if (!timeLeft) {
            return @"Loading...";
        } else if ([timeLeft containsString:@"less than"] || [timeLeft containsString:@"about"]) {
            timeLeft = [timeLeft stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[timeLeft substringToIndex:1] capitalizedString]];
        } else {
            timeLeft = [NSString stringWithFormat:@"About %@", timeLeft.lowercaseString];
        }

        return [@[ @"Syncing in progress.", timeLeft, @"remaining..." ] componentsJoinedByString:@" "];
    }

    return @"Loading...";
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
#pragma mark dependency injection

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

- (void)dealloc
{
    [self.qualityIndicator stopObservingNetworkQuality];
}

@end

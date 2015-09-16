#import "ARSyncStatusViewModel.h"
#import "NSString+TimeInterval.h"
#import "Reachability+ConnectionExists.h"
#import "NSDate+Presentation.h"


@interface ARSyncStatusViewModel ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end


@implementation ARSyncStatusViewModel

- (instancetype)initWithSync:(ARSync *)sync
{
    self = [super init];
    if (!self) return nil;

    self.sync = sync;
    self.sync.delegate = self;

    return self;
}

#pragma mark -
#pragma mark sync methods

- (void)startSync
{
    self.isSyncing = YES;
    [self.sync sync];
}

- (void)syncDidProgress:(ARSyncProgress *)progress
{
    self.timeRemainingInSync = progress.estimatedTimeRemaining;
}

- (void)syncDidFinish:(ARSync *)sync
{
    self.isSyncing = NO;
}

- (ARSyncStatus)syncStatus
{
    BOOL isOffline = ![Reachability connectionExists];

    if (isOffline) {
        return ARSyncStatusOffline;
    } else if (self.sync.isSyncing) {
        return ARSyncStatusSyncing;
    } else if ([self.defaults boolForKey:ARRecommendSync]) {
        return ARSyncStatusRecommendSync;
    } else {
        return ARSyncStatusUpToDate;
    }
}

#pragma mark -
#pragma mark sync button

- (BOOL)shouldEnableSyncButton
{
    return !(self.syncStatus == ARSyncStatusOffline);
}

- (BOOL)shouldShowSyncButton
{
    return !(self.syncStatus == ARSyncStatusSyncing);
}

- (UIColor *)syncButtonColor
{
    if (self.syncStatus == ARSyncStatusRecommendSync) return [UIColor artsyPurple];
    return [UIColor artsyHeavyGrey];
}

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

#pragma mark -
#pragma mark text methods

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

- (NSString *)syncButtonTitle
{
    if (self.syncStatus == ARSyncStatusRecommendSync) return NSLocalizedString(@"Sync New Content", @"Sync button text when we're recommending a sync");

    return NSLocalizedString(@"Sync Content", @"Sync button text after syncing completed");
}

- (NSString *)syncInProgressTitle:(NSTimeInterval)estimatedTimeRemaining
{
    NSTimeInterval remaining = estimatedTimeRemaining;
    NSTimeInterval oneDay = 86400;
    return [NSString cappedStringForTimeInterval:remaining cap:oneDay];
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

#pragma mark -
#pragma mark dependency injection

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end

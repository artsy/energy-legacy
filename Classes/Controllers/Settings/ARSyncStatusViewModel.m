#import "ARSyncStatusViewModel.h"
#import "NSString+TimeInterval.h"
#import "Reachability+ConnectionExists.h"
#import "NSDate+Presentation.h"

@interface ARSyncStatusViewModel()
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
    } else if ([self.defaults boolForKey:ARRecommendSync]) {
        return ARSyncStatusRecommendSync;
    } else if (self.sync.isSyncing) {
        return ARSyncStatusSyncing;
    } else {
        return ARSyncStatusUpToDate;
    }
}

#pragma mark -
#pragma mark text methods

- (NSString *)titleTextForStatus:(ARSyncStatus)status
{
    switch (status) {
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

- (NSString *)subtitleTextForStatus:(ARSyncStatus)status
{
    switch (status) {
        case ARSyncStatusOffline:
            return  NSLocalizedString(@"Syncing is not available offline", @"Label that tells user they cannot sync without a network connection");

        case ARSyncStatusRecommendSync:
            return [self lastSyncedString];

        case ARSyncStatusSyncing:
            return @"";

        case ARSyncStatusUpToDate:
            return [self lastSyncedString];
    }
}

- (NSString *)syncButtonTitleForStatus:(ARSyncStatus)status
{
    if (status == ARSyncStatusRecommendSync) return NSLocalizedString(@"Sync New Content", @"Sync button text when we're recommending a sync");

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

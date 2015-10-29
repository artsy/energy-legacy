#import "ARSyncAnalytics.h"

@implementation ARSyncAnalytics

- (void)syncDidStart:(ARSync *)sync
{
    [sync.defaults setBool:YES forKey:ARSyncingIsInProgress];

    BOOL completedSyncBefore = [sync.defaults boolForKey:ARFinishedFirstSync];
    [ARAnalytics event:@"sync_started" withProperties:@{
        @"initial_sync" : @(completedSyncBefore)
    }];

}

- (void)syncDidFinish:(ARSync *)sync
{
    [sync.defaults setBool:NO forKey:ARSyncingIsInProgress];

    CGFloat seconds = roundf([[NSDate date] timeIntervalSinceDate:sync.progress.startDate]);
    BOOL completedSyncBefore = [sync.defaults boolForKey:ARFinishedFirstSync];

    [ARAnalytics event:@"sync_finished" withProperties:@{
        @"seconds" : @(seconds),
        @"initial" : @(completedSyncBefore)
    }];
}

@end

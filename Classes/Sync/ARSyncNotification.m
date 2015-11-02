#import "ARSyncNotification.h"


@implementation ARSyncNotification

- (void)syncDidStart:(ARSync *)sync
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:ARSyncStartedNotification object:nil];
}

- (void)syncDidFinish:(ARSync *)sync
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:ARSyncFinishedNotification object:nil];
}

@end

#import "ARStubbedSyncDelegate.h"


@implementation ARStubbedSyncDelegate

- (void)syncDidFinish:(ARSync *)sync
{
    if (self.onSyncCompletion) self.onSyncCompletion();
}

@end

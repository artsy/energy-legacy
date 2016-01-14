#import "ARStubbedSyncDelegate.h"


@implementation ARStubbedSyncDelegate

- (void)syncDidFinish:(ARSync *)sync
{
    self.onSyncCompletion();
}

@end

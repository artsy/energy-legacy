#import "ARSync.h"

/// Sends out notifications that sync has started / finished
/// Currently on finished Grid views reload, and the
/// settings icon changes to reflect the sync status.


@interface ARSyncNotification : NSObject <ARSyncPlugin>

@end

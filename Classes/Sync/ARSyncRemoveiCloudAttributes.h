#import "ARSync.h"

/// After every sync we want to ensure that no files are sent to iCloud
/// cause that's just a waste of space.


@interface ARSyncRemoveiCloudAttributes : NSObject <ARSyncPlugin>

@end

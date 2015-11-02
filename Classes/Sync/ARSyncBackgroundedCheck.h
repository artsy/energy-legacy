#import "ARSync.h"

/// We can lose data if the app goes into the background
/// during the time that we are syncing. This plugin
/// looks out for that.


@interface ARSyncBackgroundedCheck : NSObject <ARSyncPlugin>

@property (readonly, nonatomic, getter=applicationHasBackgrounded) BOOL applicationHasGoneIntoTheBackground;

@end

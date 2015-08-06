#import "ARSync.h"
#import "ARSyncProgress.h"

/// View Controller for showing sync progewss. Has three states. Initially shows
/// a message saying what sync is, then shows some progress indication after it's over 0.01%
/// finally finishes up with an image slideshow of artworks being downloaded.


@interface ARSyncViewController : UIViewController <ARSyncDelegate, ARSyncProgressDelegate>

@property (readwrite, nonatomic, strong) NSManagedObjectContext *managedObjectContext;

/// Sets the partner name for the view controller, needs to be done after View is loaded
@property (copy, nonatomic) NSString *partnerName;

/// Set an optional status message on the screen
@property (nonatomic, copy) NSString *status;

/// Called when the sync is finished
@property (copy, nonatomic) void (^completionBlock)();

/// Has the progress indicator started showing?
- (BOOL)isShowingProgress;

/// Is the slideshow showing
- (BOOL)isShowingSlideshow;

/// Can the slideshow be turned on?
- (BOOL)canSwitchToSlideshow;

@end

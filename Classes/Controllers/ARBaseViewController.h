#import "ARSearchViewController.h"
#import "WEPopoverController.h"

extern CGFloat ARToolbarButtonDimension;

/// The ARBaseViewController is the view controller that nearly every
/// ViewController in Folio is a subclass of. At least any full screen view anyway.

/// The BaseVC handles a lot of setting up the custom UI for each view, like
/// the navigation bar and related popovers. It provides the API for adding / removing toolbar icons.


@interface ARBaseViewController : UIViewController

@property (strong) UIViewController *transparentModalViewController;

- (void)reloadData;

- (NSString *)pageID;

@end

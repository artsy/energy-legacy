#import "ARGridViewController.h"
#import "ARTabContentView.h"
#import "ARAlertViewController.h"
#import "ARPopoverController.h"
#import "ARSelectionToolbarView.h"
#import "ARCMSStatusMonitor.h"

@class ARSync;

/**  The ARTopViewController is the top view controller in the ARNavigationController, it deals with
 creating new albums, showing the Artists/Shows/Albums and hooks up a custom navbar title that is
 the switchview for these tabs. */


@interface ARTopViewController : UIViewController <ARTabViewDataSource, ARTabViewDelegate, ARModalAlertViewControllerDelegate, WYPopoverControllerDelegate>

+ (ARTopViewController *)sharedInstance;

@property (nonatomic, strong) UIViewController *transparentModalViewController;
@property (nonatomic, assign) enum ARDisplayMode displayMode;
@property (nonatomic, strong) ARSync *sync;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) ARCMSStatusMonitor *cmsMonitor;
@property (nonatomic, strong, readonly) ARSelectionToolbarView *bottomToolbar;

- (void)setDisplayMode:(enum ARDisplayMode)displayMode animated:(BOOL)animated;

- (void)reloadCurrentViewController;

- (void)toggleSettingsMenu;

- (void)toggleEditMode;

- (void)createNewAlbum;
@end

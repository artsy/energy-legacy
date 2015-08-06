#import "ARHostViewController.h"
#import "ARTabContentView.h"
#import "ARSecondarySwitchView.h"
#import "ARGridViewController.h"
#import "ARSortViewController.h"

/// The ARTabbedViewController is a ViewController that has a tab view
/// it will take any represented object and will correctly give the right
/// tabs for that object that you'd expect.

@class ARSelectionToolbarView;


@interface ARTabbedViewController : ARHostViewController <ARTabViewDelegate, ARGridViewControllerDelegate, ARSortViewControllerDelegate>

/// Presents/Hides the bottom aligned toolbar
- (void)showTopButtonToolbar:(BOOL)show animated:(BOOL)animated;

/// Presents/Hides the bottom aligned toolbar
- (void)showBottomButtonToolbar:(BOOL)show animated:(BOOL)animated;

/// A top aligned toolbar for showing buttons
@property (readonly, nonatomic, strong) ARSelectionToolbarView *topToolbar;

/// A bottom aligned toolbar for showing buttons
@property (readonly, nonatomic, strong) ARSelectionToolbarView *bottomToolbar;

/// Switch for the tabs
@property (readonly, nonatomic) ARSecondarySwitchView *switchView;

/// Selects all the items in the current tab
- (void)selectAllItems;

/// Deselects all the items in the current tab
- (void)deselectAllItems;

/// Returns whether items in the current tab are multi-selected
- (BOOL)allItemsAreSelected;

/// Returns the view controller representing the current tab
- (ARGridViewController *)currentChildController;

@end

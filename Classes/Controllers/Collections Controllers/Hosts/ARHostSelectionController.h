@class ARTabbedViewController;

/// Takes the View Controller selection state and updates the navigation bar


@interface ARHostSelectionController : NSObject

- (instancetype)initWithHostViewControlller:(ARTabbedViewController *)hostViewController;

@property (nonatomic, readonly, weak) ARTabbedViewController *hostVC;

- (void)setupDefaultToolbarItems;
- (void)selectionStateChanged;

- (void)startListening;
- (void)stopListening;

- (void)startSelectingAnimated:(BOOL)animated;
- (void)endSelectingAnimated:(BOOL)animated;

- (void)switchCancelToDone;

- (void)removeAllButtonHighlights;

@property (nonatomic, strong, readonly) UIBarButtonItem *doneActionButton;
@property (nonatomic, assign, readwrite) BOOL addEditButton;
@end

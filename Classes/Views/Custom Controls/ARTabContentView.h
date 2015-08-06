#import "ARSwitchView.h"

@class ARTabContentView;

@protocol ARTabViewDataSource <NSObject>
@required
- (UIViewController *)viewControllerForTabView:(ARTabContentView *)tabView atIndex:(NSInteger)index;

- (BOOL)tabView:(ARTabContentView *)tabView canPresentViewControllerAtIndex:(NSInteger)index;

- (NSInteger)numberOfViewControllersForTabView:(ARTabContentView *)tabView;
@end

@protocol ARTabViewDelegate <NSObject>
@optional
- (void)tabView:(ARTabContentView *)tabView didChangeSelectedIndex:(NSInteger)index animated:(BOOL)animated;
@end

/**

 The ARTabContentView is a Child View Controller compliant tab view, it is only the viewport itself,
 and is a view for a view controller like ARTabbedViewController, or ARTopViewController.

 ViewControllers are added as children to the hostVC, and it has built-in support for hooking
 up with the ARSwitchView subclasses for the usual tab & switch.

 **/


@interface ARTabContentView : UIView <ARSwitchViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame hostViewController:(UIViewController *)controller delegate:(id<ARTabViewDelegate>)delegate dataSource:(id<ARTabViewDataSource>)dataSource;

@property (nonatomic, weak) ARSwitchView *switchView;
@property (nonatomic, weak, readonly) UIViewController *hostViewController;

@property (nonatomic, weak) id<ARTabViewDelegate> delegate;
@property (nonatomic, weak) id<ARTabViewDataSource> dataSource;

@property (nonatomic, strong, readonly) UIViewController *currentViewController;
@property (nonatomic, assign) BOOL supportSwipeGestures;

@property (nonatomic, strong, readonly) NSMutableArray *views;
@property (nonatomic, strong, readonly) UISwipeGestureRecognizer *leftSwipeGesture;
@property (nonatomic, strong, readonly) UISwipeGestureRecognizer *rightSwipeGesture;

@property (nonatomic, assign, readonly) NSInteger currentViewIndex;

- (void)setCurrentViewIndex:(NSInteger)currentViewIndex animated:(BOOL)animated;

// Move to the next or previous tab, if you're at the end it does nothing
- (void)showNextTabAnimated:(BOOL)animated;

- (void)showPreviousTabAnimated:(BOOL)animated;
@end

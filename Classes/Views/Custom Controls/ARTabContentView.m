#import "ARTabContentView.h"

static BOOL ARTabViewDirectionLeft = NO;
static BOOL ARTabViewDirectionRight = YES;


@interface ARTabContentView ()
@end


@implementation ARTabContentView

- (instancetype)initWithFrame:(CGRect)frame hostViewController:(UIViewController *)controller delegate:(id<ARTabViewDelegate>)delegate dataSource:(id<ARTabViewDataSource>)dataSource
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.opaque = YES;
    self.clipsToBounds = YES;

    _hostViewController = controller;
    _delegate = delegate;
    _dataSource = dataSource;

    _leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedViewLeft:)];
    _leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_leftSwipeGesture];

    _rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedViewRight:)];
    _rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:_rightSwipeGesture];

    return self;
}

- (void)removeFromSuperview
{
    [_currentViewController willMoveToParentViewController:nil];
    [_currentViewController removeFromParentViewController];

    [super removeFromSuperview];
}

#pragma mark -
#pragma mark Custom Properties

- (void)setSupportSwipeGestures:(BOOL)supportSwipeGestures
{
    self.leftSwipeGesture.enabled = supportSwipeGestures;
    self.rightSwipeGesture.enabled = supportSwipeGestures;
}

- (void)setSwitchView:(ARSwitchView *)switchView
{
    _switchView = switchView;
    self.switchView.delegate = self;

    [self updateSwitchViewEnabledStates];
}

- (void)updateSwitchViewEnabledStates
{
    self.switchView.enabledStates = [self.switchView.titles map:^id(id object) {
        NSInteger index = [self.switchView.titles indexOfObject:object];
        return @([self.dataSource tabView:self canPresentViewControllerAtIndex:index]);
    }];
}

#pragma mark -
#pragma mark Gestures

- (void)swipedViewRight:(UISwipeGestureRecognizer *)gesture
{
    [self showPreviousTabAnimated:YES];
}

- (void)showPreviousTabAnimated:(BOOL)animated
{
    NSInteger nextIndex = [self nextEnabledIndexInDirection:ARTabViewDirectionLeft];

    if (self.currentViewIndex != nextIndex) {
        self.currentViewIndex = nextIndex;
        [self.switchView setSelectedIndex:nextIndex animated:animated];
    }
}

- (void)swipedViewLeft:(UISwipeGestureRecognizer *)gesture
{
    [self showNextTabAnimated:YES];
}

- (void)showNextTabAnimated:(BOOL)animated
{
    NSInteger nextIndex = [self nextEnabledIndexInDirection:ARTabViewDirectionRight];
    if (self.currentViewIndex != nextIndex) {
        self.currentViewIndex = nextIndex;
        [self.switchView setSelectedIndex:nextIndex animated:animated];
    }
}

- (NSInteger)nextEnabledIndexInDirection:(BOOL)direction
{
    // can't go any further
    if (self.currentViewIndex == 0 && direction == ARTabViewDirectionLeft) return self.currentViewIndex;
    if (self.currentViewIndex == [self numberOfViewControllers] - 1 && direction == ARTabViewDirectionRight) return self.currentViewIndex;

    NSInteger nextViewIndex = direction ? self.currentViewIndex + 1 : self.currentViewIndex - 1;
    // loop until we hit an enabled view
    while (![self.dataSource tabView:self canPresentViewControllerAtIndex:nextViewIndex]) {
        if (direction) {
            nextViewIndex++;
        } else {
            nextViewIndex--;
        }

        // if we're going to go too far, stop and return the current index
        if (nextViewIndex == -1) return self.currentViewIndex;
        if (nextViewIndex == [self numberOfViewControllers]) return self.currentViewIndex;
    }

    return nextViewIndex;
}

- (NSInteger)numberOfViewControllers
{
    return [self.dataSource numberOfViewControllersForTabView:self];
}

#pragma mark -
#pragma mark Setting the Current View Index

- (void)setCurrentViewIndex:(NSInteger)currentViewIndex
{
    [self setCurrentViewIndex:currentViewIndex animated:YES];
}

- (void)setCurrentViewIndex:(NSInteger)currentViewIndex animated:(BOOL)animated
{
    // Setup positions of views
    NSInteger direction = (_currentViewIndex > currentViewIndex) ? -1 : 1;
    CGRect nextViewInitialFrame = self.bounds;
    CGRect oldViewEndFrame = self.bounds;
    nextViewInitialFrame.origin.x = direction * CGRectGetWidth(self.superview.bounds);
    oldViewEndFrame.origin.x = -direction * CGRectGetWidth(self.superview.bounds);

    __block UIViewController *oldViewController = self.currentViewController;
    _currentViewIndex = currentViewIndex;

    // Get the next View Controller, add to self
    _currentViewController = [self viewControllerForIndex:currentViewIndex];
    self.currentViewController.view.frame = nextViewInitialFrame;

    if ([self.delegate respondsToSelector:@selector(tabView:didChangeSelectedIndex:animated:)]) {
        [self.delegate tabView:self didChangeSelectedIndex:currentViewIndex animated:animated];
    }

    // Add the new ViewController our view's host
    [self.hostViewController addChildViewController:self.currentViewController];
    [self.currentViewController didMoveToParentViewController:_hostViewController];

    void (^animationBlock)();
    animationBlock = ^{
        self.currentViewController.view.frame = self.bounds;
        oldViewController.view.frame = oldViewEndFrame;
    };

    void (^completionBlock)(BOOL finished);
    completionBlock = ^(BOOL finished) {
        // Remove the old one
        [oldViewController willMoveToParentViewController:nil];

        [oldViewController removeFromParentViewController];
        [oldViewController.view removeFromSuperview];
    };

    ar_dispatch_main_queue(^{

        if (animated && oldViewController && oldViewController.parentViewController) {
            [self.currentViewController.view layoutIfNeeded];
            [self.hostViewController transitionFromViewController:oldViewController toViewController:self.currentViewController duration:0.3 options:0 animations:animationBlock completion:completionBlock];
        } else {
            [self.currentViewController beginAppearanceTransition:YES animated:NO];
            [self addSubview:self.currentViewController.view];
            [self.currentViewController endAppearanceTransition];

            animationBlock();
            completionBlock(YES);
        }
    });
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index
{
    UIViewController *currentViewController = [self.dataSource viewControllerForTabView:self atIndex:index];

    // Remove from other parent (if any)
    [currentViewController willMoveToParentViewController:nil];
    [currentViewController removeFromParentViewController];

    return currentViewController;
}

- (void)switchView:(ARSwitchView *)switchView didSelectIndex:(NSInteger)index animated:(BOOL)animated
{
    [self setCurrentViewIndex:index animated:YES];
}

@end

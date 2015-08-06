#import "ARPagingArtworkViewController.h"
#import "ARImageViewController.h"

static const NSInteger ARDragMarginForShowingArtworks = 70;


@interface ARPagingArtworkViewController () <UIGestureRecognizerDelegate>
@end


@implementation ARPagingArtworkViewController

- (instancetype)initWithDelegate:(id<ARPagingArtworkDataSource>)delegate index:(NSInteger)index
{
    NSParameterAssert(delegate);

    NSDictionary *options = @{ UIPageViewControllerOptionInterPageSpacingKey : @(12) };
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    if (!self) return nil;

    self.dataSource = self;

    _pagingDelegate = delegate;
    _index = index;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ARImageViewController *artworkVC = [self viewControllerForIndex:self.index];

    [self setViewControllers:@[ artworkVC ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedPage:)];
    panGesture.cancelsTouchesInView = NO;
    panGesture.delegate = self;

    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:UIScrollView.class]) {
            [view addGestureRecognizer:panGesture];
        }
    }
}

#pragma mark -
#pragma mark Page view controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ARImageViewController *)viewController
{
    NSInteger index = viewController.index - 1;
    if (index == -1) {
        return nil;
    };

    return [self viewControllerForIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ARImageViewController *)viewController
{
    NSInteger index = viewController.index + 1;

    if (index == self.pagingDelegate.artworkCount) {
        return nil;
    }

    return [self viewControllerForIndex:index];
}

- (ARImageViewController *)viewControllerForIndex:(NSInteger)index
{
    Artwork *artwork = [self.pagingDelegate artworkAtIndex:index];
    if (!artwork) return nil;

    ARImageViewController *artworkViewController = [[ARImageViewController alloc] initWithImage:artwork.mainImage];
    artworkViewController.index = index;

    return artworkViewController;
}

#pragma mark -
#pragma mark Panned Page

- (void)pannedPage:(UIPanGestureRecognizer *)tapGesture
{
    UIScrollView *scrollView = (id)tapGesture.view;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = [self.viewControllers.firstObject index];

    if (index == 0) {
        if (x < CGRectGetWidth(scrollView.bounds) - ARDragMarginForShowingArtworks) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ARArtworkEnsureShowingMetadataNotification object:nil];
        }

    } else if (index == self.pagingDelegate.artworkCount - 1) {
        if (x > CGRectGetWidth(scrollView.bounds) + ARDragMarginForShowingArtworks) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ARArtworkEnsureShowingMetadataNotification object:nil];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

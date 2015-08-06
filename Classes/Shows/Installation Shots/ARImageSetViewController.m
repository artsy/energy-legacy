#import "ARImageSetViewController.h"
#import "ARImageViewController.h"


@interface ARImageSetViewController () <UIPageViewControllerDataSource>

@end


@implementation ARImageSetViewController

- (instancetype)initWithImages:(NSArray *)images atIndex:(NSInteger)index
{
    NSDictionary *options = @{ UIPageViewControllerOptionInterPageSpacingKey : @(12) };
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    if (!self) return nil;

    _images = images;
    _index = index;
    self.dataSource = self;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor artsyBackgroundColor];
    ARImageViewController *artworkVC = [self viewControllerForIndex:self.index];
    [self setViewControllers:@[ artworkVC ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

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

    if (index == self.images.count) {
        return nil;
    }

    return [self viewControllerForIndex:index];
}

- (ARImageViewController *)viewControllerForIndex:(NSInteger)index
{
    Image *image = self.images[index];
    if (!image) return nil;


    ARImageViewController *artworkViewController = [[ARImageViewController alloc] initWithImage:image];
    artworkViewController.index = index;

    return artworkViewController;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

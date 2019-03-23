#import "ARPrefersHiddenStatusBarViewController.h"


@implementation ARPrefersHiddenStatusBarViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

// This peaks out on an iPhone X

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

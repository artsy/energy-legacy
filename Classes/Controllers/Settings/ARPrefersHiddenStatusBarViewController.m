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
    if ([UIDevice isPad]) {
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

@end

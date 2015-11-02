#import "ARLabSettingsSplitViewController.h"
#import "ARTopViewController.h"
#import "ARLabSettingsDetailViewManager.h"

@implementation ARLabSettingsSplitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.preferredDisplayMode = [UIDevice isPad] ? UISplitViewControllerDisplayModeAllVisible : UISplitViewControllerDisplayModeAutomatic;
    self.preferredPrimaryColumnWidthFraction = 0.4;
    
}

#pragma mark - exit strategy

- (void)exitSettingsPanel
{
    @try {
        [[self valueForKey:@"_hiddenPopoverController"] dismissPopoverAnimated:YES];
    }
    @catch (__unused NSException *exception) {
    }

    [[ARTopViewController sharedInstance] dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

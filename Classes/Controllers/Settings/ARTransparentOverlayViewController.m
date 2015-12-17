#import "ARTransparentOverlayViewController.h"
#import "ARLabSettingsSplitViewController.h"


@implementation ARTransparentOverlayViewController

- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer
{
    [(ARLabSettingsSplitViewController *)self.splitViewController exitSettingsPanel];
}

@end

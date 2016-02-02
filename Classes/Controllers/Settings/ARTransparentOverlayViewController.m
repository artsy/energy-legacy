#import "ARTransparentOverlayViewController.h"
#import "ARSettingsSplitViewController.h"


@implementation ARTransparentOverlayViewController

- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer
{
    [(ARSettingsSplitViewController *)self.splitViewController exitSettingsPanel];
}

@end

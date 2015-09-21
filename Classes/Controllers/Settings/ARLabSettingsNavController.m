#import "ARLabSettingsNavController.h"
#import "ARLabSettingsViewController.h"


@implementation ARLabSettingsNavController

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    NSAssert([self.parentViewController isKindOfClass:ARLabSettingsViewController.class], @"Parent has to be an ARLabSettingsVC");
    [(ARLabSettingsViewController *)self.parentViewController exitSettingsPanel];
}

@end

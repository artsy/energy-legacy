#import <UIKit/UIKit.h>

@class ARPopoverController;


@interface ARSettingsNavigationController : UINavigationController

@property (readwrite, nonatomic, weak) ARPopoverController *hostPopoverController;

@end

#import <UIKit/UIKit.h>


@interface ARToggleSwitch : UIButton

+ (instancetype)button;

@property (nonatomic, getter=isOn) BOOL on;
@end

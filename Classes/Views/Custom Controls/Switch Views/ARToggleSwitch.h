#import <UIKit/UIKit.h>


@interface ARToggleSwitch : UIButton

+ (instancetype)buttonWithFrame:(CGRect)frame;

@property (nonatomic, getter=isOn) BOOL on;
@end

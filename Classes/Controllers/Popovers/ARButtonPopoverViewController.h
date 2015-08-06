#import <UIKit/UIKit.h>
#import "ARFlatButton.h"

typedef enum _ARButtonPopoverViewControllerStyle {
    ARButtonPopoverDefault,
    ARButtonPopoverDestructive
} ARButtonPopoverViewControllerStyle;


@interface ARButtonPopoverViewController : UIViewController
- (instancetype)initWithButton:(ARFlatButton *)theButton andStyle:(NSInteger)style;
@end

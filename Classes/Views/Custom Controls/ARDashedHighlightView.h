#import <UIKit/UIKit.h>


@interface ARDashedHighlight : NSObject
+ (void)highlightView:(UIView *)targetView animated:(BOOL)animated;

+ (void)removeHighlight:(UIView *)targetView animated:(BOOL)animated;
@end

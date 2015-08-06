#import <UIKit/UIKit.h>


@interface ARAnimatedTickView : UIView
- (instancetype)initWithSelection:(BOOL)selected;

- (BOOL)selected;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end

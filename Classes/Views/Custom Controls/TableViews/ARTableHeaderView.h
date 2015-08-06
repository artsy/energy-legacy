#import <UIKit/UIKit.h>

NS_ENUM(NSInteger, ARTableHeaderViewStyle){
    ARTableHeaderViewStyleDark,
    ARTableHeaderViewStyleLight};


@interface ARTableHeaderView : UIView

+ (CGFloat)heightOfCell;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title style:(enum ARTableHeaderViewStyle)style;

@end

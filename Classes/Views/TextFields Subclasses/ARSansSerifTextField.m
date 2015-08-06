#import "ARSansSerifTextField.h"


@implementation ARSansSerifTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textAlignment = NSTextAlignmentCenter;
        self.borderStyle = UITextBorderStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textColor = [UIColor blackColor];
    }
    return self;
}

@end

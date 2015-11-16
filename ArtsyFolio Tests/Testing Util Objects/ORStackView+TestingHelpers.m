#import "ORStackView+TestingHelpers.h"


@implementation ORStackView (TestingHelpers)

- (BOOL)containsLabelWithText:(NSString *)text
{
    return [self.subviews find:^BOOL(UIView *subview) {
        BOOL isLabel = [subview isKindOfClass:UILabel.class];
        return isLabel && ([((UILabel *)subview).text caseInsensitiveCompare:text] == NSOrderedSame);

    }] != nil;
}

@end

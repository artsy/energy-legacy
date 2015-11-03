#import "NSString+NiceAttributedStrings.h"


@implementation NSString (NiceAttributedStrings)

- (NSAttributedString *)attributedStringWithLineSpacing:(CGFloat)spacing
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:spacing];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.length)];
    return attrString;
}

- (NSAttributedString *)attributedStringWithKern:(CGFloat)kern
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    [attrString addAttribute:NSKernAttributeName value:@(kern) range:NSMakeRange(0, self.length)];
    return attrString;
}


@end

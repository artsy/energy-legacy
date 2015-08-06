#import "ARDateLabel.h"
#import <CoreText/CoreText.h>


@interface ARSerifLabel ()
- (void)setup;
@end


@implementation ARDateLabel

- (void)setup
{
    [super setup];
    self.backgroundColor = [UIColor artsyBackgroundColor];
    self.textColor = [UIColor artsyForegroundColor];
}

- (void)setText:(id)aText
{
    if ([aText respondsToSelector:@selector(string)] && self.suppressDateFormatting == NO) {
        NSMutableAttributedString *text = aText;
        NSInteger lastCommaIndex = [[text string] rangeOfString:@", " options:NSBackwardsSearch].location;

        // if we find a comma with a space, make the text after it
        // have an attribute of garamond regular instead of italics

        if (lastCommaIndex != NSNotFound && [aText respondsToSelector:@selector(addAttribute:value:range:)]) {
            NSString *fontName = @"AGaramondPro-Regular";
            NSRange range = NSMakeRange(lastCommaIndex, [[text string] length] - lastCommaIndex);

            CTFontRef aFont = CTFontCreateWithName((CFStringRef)fontName, self.font.pointSize, NULL);
            [text addAttribute:(NSString *)kCTFontAttributeName value:(id)aFont range:range];
            CFRelease(aFont);

            [super setAttributedText:text];
            return;
        }
    }

    [super setText:aText];
}
@end

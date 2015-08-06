#import "ARInsetTextField.h"


@implementation ARInsetTextField

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

// placeholder
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.contentInset);
}

// text
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.contentInset);
}

@end



@implementation NSString (StringSize)

- (CGSize)ar_sizeWithFont:(UIFont *)font
{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName : font}];
    return (CGSize){ceilf(size.height), ceilf(size.width)};
}

- (CGSize)ar_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self ar_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)ar_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width
{
    return [self ar_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)ar_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreak
{
    return CGRectIntegral([self boundingRectWithSize:size
                                             options:lineBreak | NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName : font }
                                             context:nil])
        .size;
}

@end

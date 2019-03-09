


@implementation NSString (StripHTML)

- (NSString *)stringByStrippingHTML
{
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *wrappedString = [[[NSAttributedString alloc] initWithData:stringData
                                                                options:@{
                                                                    NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                                    NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)
                                                                }
                                                     documentAttributes:nil
                                                                  error:nil] string];

    if ([wrappedString hasSuffix:@"\n"]) {
        return [wrappedString substringWithRange:NSMakeRange(0, wrappedString.length - 1)];
    } else {
        return wrappedString;
    }
}
@end

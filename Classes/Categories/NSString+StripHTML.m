


@implementation NSString (StripHTML)

- (NSString *)stringByStrippingHTML
{
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [[[NSAttributedString alloc] initWithData:stringData
                                             options:@{
                                                 NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                                 NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)
                                             }
                                  documentAttributes:nil
                                               error:nil] string];
}
@end

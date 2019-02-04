//  Taken from here: http://www.codeilove.com/2011/09/ios-dev-strip-html-tags-from-nsstring.html
//  I've Cleaned it up, and ARC'd  ./


@interface NSString_stripHtml_XMLParsee : NSObject <NSXMLParserDelegate>
{
   @private
    NSMutableArray *strings;
}
- (NSString *)getCharsFound;
@end


@implementation NSString_stripHtml_XMLParsee

- (id)init
{
    if ((self = [super init])) {
        strings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [strings addObject:string];
}

- (NSString *)getCharsFound
{
    return [strings componentsJoinedByString:@""];
}
@end


@implementation NSString (StripHTML)

- (NSString *)stringByStrippingHTML
{
    //    NSString *fontFamily = [UIFont serifFontWithSize:12].familyName ;
    //    NSString *styledSelf = [NSString stringWithFormat: @"<style>p { font-size: 14px; font-family: '%@'; margin-top: 0; }</style><p>%@</p>", fontFamily, self];
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

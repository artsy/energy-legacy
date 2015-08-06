#import "NSDictionary+QueryString.h"


@implementation NSDictionary (QueryString)

+ (NSString *)URLEscape:(NSString *)unencodedString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                           (CFStringRef)unencodedString,
                                                                           NULL,
                                                                           (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
                                                                           kCFStringEncodingUTF8);
    return [result autorelease];
}

- (NSString *)queryString
{
    NSMutableString *urlWithQuery = [[[NSMutableString alloc] init] autorelease];
    for (id key in [self allKeys]) {
        NSString *sKey = [key description];
        NSString *sVal = [self[key] description];
        // Do we need to add ?k=v or &k=v ?
        if ([urlWithQuery rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuery appendFormat:@"?%@=%@", [NSDictionary URLEscape:sKey], [NSDictionary URLEscape:sVal]];
        } else {
            [urlWithQuery appendFormat:@"&%@=%@", [NSDictionary URLEscape:sKey], [NSDictionary URLEscape:sVal]];
        }
    }
    return urlWithQuery;
}

@end

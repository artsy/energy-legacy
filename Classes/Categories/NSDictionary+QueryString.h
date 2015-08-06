#import <Foundation/Foundation.h>


@interface NSDictionary (QueryString)
+ (NSString *)URLEscape:(NSString *)unencodedString;

- (NSString *)queryString;
@end

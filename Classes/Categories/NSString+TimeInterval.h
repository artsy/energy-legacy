#import <Foundation/Foundation.h>


@interface NSString (TimeInterval)
+ (NSString *)cappedStringForTimeInterval:(NSTimeInterval)interval cap:(NSTimeInterval)cap;

+ (NSString *)stringForTimeInterval:(NSTimeInterval)interval includeSeconds:(BOOL)includeSeconds;
@end

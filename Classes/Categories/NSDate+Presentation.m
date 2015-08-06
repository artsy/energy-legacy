#import "NSDate+Presentation.h"


@implementation NSDate (Presentation)

- (NSString *)formattedString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:calendar];

    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    [dateFormatter setTimeZone:timeZone];

    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:self];
}

@end

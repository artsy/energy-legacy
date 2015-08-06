
#import "NSString+TimeInterval.h"


@implementation NSString (TimeInterval)

+ (NSString *)cappedStringForTimeInterval:(NSTimeInterval)interval cap:(NSTimeInterval)cap
{
    if (interval > cap) return nil;
    return [NSString stringForTimeInterval:interval includeSeconds:NO];
}

+ (NSString *)stringForTimeInterval:(NSTimeInterval)interval includeSeconds:(BOOL)includeSeconds
{
    NSTimeInterval intervalInSeconds = fabs(interval);
    double intervalInMinutes = round(intervalInSeconds / 60.0);

    if (intervalInMinutes >= 0 && intervalInMinutes <= 1) {
        if (!includeSeconds) return intervalInMinutes == 0 ? @"less than a minute" : @"1 minute";
        if (intervalInSeconds >= 0 && intervalInSeconds <= 4)
            return @"less than 5 seconds";
        else if (intervalInSeconds >= 5 && intervalInSeconds <= 9)
            return @"less than 10 seconds";
        else if (intervalInSeconds >= 10 && intervalInSeconds <= 19)
            return @"less than 20 seconds";
        else if (intervalInSeconds >= 20 && intervalInSeconds <= 39)
            return @"half a minute";
        else if (intervalInSeconds >= 40 && intervalInSeconds <= 59)
            return @"less than a minute";
        else
            return @"1 minute";
    }

    else if (intervalInMinutes >= 2 && intervalInMinutes <= 44)
        return [NSString stringWithFormat:@"%.0f minutes", intervalInMinutes];
    else if (intervalInMinutes >= 45 && intervalInMinutes <= 89)
        return @"about 1 hour";
    else if (intervalInMinutes >= 90 && intervalInMinutes <= 1439)
        return [NSString stringWithFormat:@"about %.0f hours", round(intervalInMinutes / 60.0)];
    else if (intervalInMinutes >= 1440 && intervalInMinutes <= 2879)
        return @"1 day";
    else if (intervalInMinutes >= 2880 && intervalInMinutes <= 43199)
        return [NSString stringWithFormat:@"%.0f days", round(intervalInMinutes / 1440.0)];
    else if (intervalInMinutes >= 43200 && intervalInMinutes <= 86399)
        return @"about 1 month";
    else if (intervalInMinutes >= 86400 && intervalInMinutes <= 525599)
        return [NSString stringWithFormat:@"%.0f months", round(intervalInMinutes / 43200.0)];
    else if (intervalInMinutes >= 525600 && intervalInMinutes <= 1051199)
        return @"about 1 year";
    return [NSString stringWithFormat:@"over %.0f years", round(intervalInMinutes / 525600.0)];
}

@end

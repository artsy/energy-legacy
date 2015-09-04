#import "NSDictionary+ObjectForKey.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

static ISO8601DateFormatter *dateFormatter;


@implementation NSDictionary (ObjectForKey)

- (NSString *)onlyStringForKey:(NSString *)key
{
    id object = self[key];
    if ([object isKindOfClass:[NSString class]]) {
        // Ensure its not a whitespace only string, no-one wants to go into
        // additional metadata and see nothing.

        NSString *removedWhitespace = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![@"" isEqualToString:removedWhitespace]) {
            return object;
        }
    }
    return nil;
}

- (NSDictionary *)onlyDictionaryForKey:(NSString *)key
{
    id object = self[key];
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    }
    return nil;
}

- (NSArray *)onlyArrayForKey:(NSString *)key
{
    id object = self[key];
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    }
    return nil;
}

- (NSNumber *)onlyNumberForKey:(NSString *)key
{
    id object = self[key];
    if ([object isKindOfClass:[NSNumber class]]) {
        return object;
    }
    // could still be a string
    if ([object isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithInteger:[object integerValue]];
    }
    return nil;
}

- (NSDecimalNumber *)onlyDecimalForKey:(NSString *)key
{
    id object = self[key];
    if ([object isKindOfClass:[NSDecimalNumber class]]) {
        return object;
    }
    // could still be a string
    if ([object isKindOfClass:[NSString class]] && ![object isEqualToString:@""]) {
        return [NSDecimalNumber decimalNumberWithString:object];
    }
    return nil;
}

- (id)objectForKeyNotNull:(id)key
{
    id object = self[key];
    if (object == [NSNull null])
        return nil;

    return object;
}

- (NSDate *)onlyDateFromStringForKey:(NSString *)key
{
    if (!dateFormatter) {
        dateFormatter = [[ISO8601DateFormatter alloc] init];
    }

    NSString *string = [self onlyStringForKey:key];
    if (string) {
        return [dateFormatter dateFromString:string];
    }
    return nil;
}

@end

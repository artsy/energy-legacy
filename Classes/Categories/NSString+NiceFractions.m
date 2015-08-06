#import "NSString+NiceFractions.h"

static NSRegularExpression *fractionRegex;


@implementation NSString (NiceFractions)
+ (NSString *)stringByMakingFractionsLookNice:(NSString *)original
{
    if (original == nil) {
        return nil;
    }
    if (!fractionRegex) {
        //word boundary, (one or more digits), slash, (one or more digits), word boundary
        fractionRegex = [NSRegularExpression regularExpressionWithPattern:@"\\b(\\d+)/(\\d+)\\b"
                                                                  options:0
                                                                    error:nil];
    }
    NSArray *matches = [fractionRegex matchesInString:original
                                              options:0
                                                range:NSMakeRange(0, [original length])];
    NSMutableString *result = [original mutableCopy];
    NSMutableString *fixed;
    for (NSTextCheckingResult *match in matches) {
        fixed = [[NSMutableString alloc] init];
        [fixed appendString:
                   [NSString superscriptOf:
                                 [original substringWithRange:
                                               [match rangeAtIndex:1]]]];
        [fixed appendString:@"\u2044"]; //fraction slash
        [fixed appendString:
                   [NSString subscriptOf:
                                 [original substringWithRange:
                                               [match rangeAtIndex:2]]]];
        [result replaceCharactersInRange:[match rangeAtIndex:0] withString:fixed];
    }
    return result;
}

//adapted from http://stackoverflow.com/a/7937760/1195214
+ (NSString *)superscriptOf:(NSString *)inputNumber
{
    NSMutableString *result = [NSMutableString stringWithCapacity:[inputNumber length]];
    for (int i = 0; i < [inputNumber length]; i++) {
        unichar chara = [inputNumber characterAtIndex:i];
        switch (chara) {
            case '1':
                [result appendString:@"\u00B9"];
                break;
            case '2':
                [result appendString:@"\u00B2"];
                break;
            case '3':
                [result appendString:@"\u00B3"];
                break;
            case '4':
                [result appendString:@"\u2074"];
                break;
            case '5':
                [result appendString:@"\u2075"];
                break;
            case '6':
                [result appendString:@"\u2076"];
                break;
            case '7':
                [result appendString:@"\u2077"];
                break;
            case '8':
                [result appendString:@"\u2078"];
                break;
            case '9':
                [result appendString:@"\u2079"];
                break;
            case '0':
                [result appendString:@"\u2070"];
                break;
            default:
                break;
        }
    }
    return result;
}

+ (NSString *)subscriptOf:(NSString *)inputNumber
{
    NSMutableString *result = [NSMutableString stringWithCapacity:[inputNumber length]];
    for (int i = 0; i < [inputNumber length]; i++) {
        unichar chara = [inputNumber characterAtIndex:i];
        switch (chara) {
            case '1':
                [result appendString:@"\u2081"];
                break;
            case '2':
                [result appendString:@"\u2082"];
                break;
            case '3':
                [result appendString:@"\u2083"];
                break;
            case '4':
                [result appendString:@"\u2084"];
                break;
            case '5':
                [result appendString:@"\u2085"];
                break;
            case '6':
                [result appendString:@"\u2086"];
                break;
            case '7':
                [result appendString:@"\u2087"];
                break;
            case '8':
                [result appendString:@"\u2088"];
                break;
            case '9':
                [result appendString:@"\u2089"];
                break;
            case '0':
                [result appendString:@"\u2080"];
                break;
            default:
                break;
        }
    }
    return result;
}
@end

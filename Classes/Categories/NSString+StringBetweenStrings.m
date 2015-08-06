

@implementation NSString (StringBetweenStrings)

- (NSString *)substringBetween:(NSString *)start and:(NSString *)end
{
    NSRange startingRange = [self rangeOfString:start];
    NSRange endingRange = [self rangeOfString:end];

    if (startingRange.location == NSNotFound || endingRange.location == NSNotFound) {
        return nil;
    }

    NSUInteger length = endingRange.location - startingRange.location - startingRange.length;
    NSUInteger location = startingRange.location + startingRange.length;

    if (length + location > self.length) {
        return nil;
    }

    return [self substringWithRange:NSMakeRange(location, length)];
}

@end

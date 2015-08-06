#import "UIDevice+Testing.h"


@implementation UIDevice (Testing)

// Thanks https://github.com/pietbrauer

static BOOL ARRunningUnitTests = NO;

+ (BOOL)isRunningUnitTests
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSString *XCInjectBundle = [[[NSProcessInfo processInfo] environment] objectForKey:@"XCInjectBundle"];

        ARRunningUnitTests = [XCInjectBundle hasSuffix:@".xctest"];
    });

    return ARRunningUnitTests;
}

@end

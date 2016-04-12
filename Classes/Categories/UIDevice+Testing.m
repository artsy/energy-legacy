#import "UIDevice+Testing.h"


@implementation UIDevice (Testing)

+ (BOOL)isRunningUnitTests
{
    return NSClassFromString(@"XCTestCase") != nil;
}

@end

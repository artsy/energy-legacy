#import <objc/runtime.h>


@interface XCTest (OHHTTPAutoStub)
@end


@implementation XCTest (OHHTTPAutoStub)

+ (void)load
{
    Method original, swizzled;

    original = class_getInstanceMethod(self, @selector(tearDown));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_tearDown));
    method_exchangeImplementations(original, swizzled);
}

- (void)swizzled_tearDown
{
    [OHHTTPStubs removeAllStubs];
    [self swizzled_tearDown];
}

@end

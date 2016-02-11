#import "AROHHTTPNoStubAssertionBot.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "ARFilteredStackTrace.h"
#import <objc/runtime.h>

@class OHHTTPStubsDescriptor;


@interface OHHTTPStubs (PrivateStuff)
+ (instancetype)sharedInstance;
- (OHHTTPStubsDescriptor *)firstStubPassingTestForRequest:(NSURLRequest *)request;
@end


@interface ARHTTPStubs : OHHTTPStubs
@end


@implementation ARHTTPStubs

- (OHHTTPStubsDescriptor *)firstStubPassingTestForRequest:(NSURLRequest *)request
{
    id stub = [super firstStubPassingTestForRequest:request];
    if (stub) {
        return stub;
    }

    if (!request.URL) {
        return nil;
    }

    // Skip http://itunes.apple.com/US/lookup?bundleId=net.artsy.artsy.dev
    if ([request.URL.host hasSuffix:@"apple.com"]) {
        return nil;
    }

    id spectaExample = [[NSThread mainThread] threadDictionary][@"SPTCurrentSpec"];
    id expectaMatcher = [[NSThread mainThread] threadDictionary][@"EXP_currentMatcher"];

    if (spectaExample || expectaMatcher) {
        static NSArray *whiteList = nil;
        if (whiteList == nil) whiteList = @[ [NSBundle mainBundle], [NSBundle bundleForClass:ARHTTPStubs.class] ];
        NSArray *stackTrace = ARFilteredStackTraceWithWhiteList(1, whiteList, ^BOOL(BOOL blockInvocation,
                                                                                    BOOL objcMethod,
                                                                                    BOOL classMethod,
                                                                                    NSString *className,
                                                                                    NSString *methodOrFunction) {
            return !(
                     ([className isEqualToString:@"ArtsyAPI"] && [methodOrFunction hasPrefix:@"getRequest:parseInto"])
                     || [methodOrFunction hasPrefix:@"ar_dispatch"]
                     || [methodOrFunction isEqualToString:@"main"]
                     );
        });
        NSAssert(stackTrace.count > 0, @"Stack trace empty, might need more white listing.");

        printf("\n\n\n[!] Unstubbed Request Found\n");
        printf("   Inside Test: %s\n", [spectaExample description].UTF8String);
        printf("       Matcher: %s\n", [expectaMatcher description].UTF8String);
        printf("Un-stubbed URL: %s\n", request.URL.absoluteString.UTF8String);
        printf("You should use: [OHHTTPStubs stubJSONResponseAtPath:@\"%s\" withResponse:@{}];\n", request.URL.path.UTF8String);
        printf("   Stack trace: %s\n\n\n\n", [stackTrace componentsJoinedByString:@"\n                "].UTF8String);
    }

    _XCTPrimitiveFail(spectaExample, @"Failed due to unstubbed networking.");
    return nil;
}

@end


@implementation AROHHTTPNoStubAssertionBot

+ (BOOL)assertOnFailForGlobalOHHTTPStubs
{
    id newClass = object_setClass([OHHTTPStubs sharedInstance], ARHTTPStubs.class);
    return newClass != nil;
}

@end

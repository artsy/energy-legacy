#import "AROHHTTPNoStubAssertionBot.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
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

    // Skip http://itunes.apple.com/US/lookup?bundleId=net.artsy.artsy.dev
    if ([request.URL.host hasSuffix:@"apple.com"]) {
        return nil;
    }

    NSLog(@"\n\n\n\n");
    NSLog(@"----------------- Found an unstubbed request");
    NSLog(@" - %@", request.HTTPMethod);
    NSLog(@" - %@", request.URL.absoluteString);

    if (request.allHTTPHeaderFields) {
        NSLog(@" - %@", request.allHTTPHeaderFields);
    }

    if (request.HTTPBody) {
        NSLog(@" - %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSASCIIStringEncoding]);
    }

    NSLog(@"----------------- ");
    NSLog(@"\n\n\n\n");

    id compiledExample = [[NSThread currentThread] threadDictionary][@"SPTCurrentSpec"]; // SPTSpec
    _XCTPrimitiveFail(compiledExample, @"FAIL");
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

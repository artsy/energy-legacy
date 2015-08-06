

@implementation OHHTTPStubs (QuickStubs)

+ (void)stubAllRequestsReturningJSONWithObject:(id)object
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Accepting request %@", request.URL);
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:@{ @"Content-Type": @"application/json" }];
    }];
}

+ (void)stubRequestsMatchingPath:(NSString *)address returningJSONWithObject:(id)object
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"--> %@", request.URL.path);
        return [request.URL.path isEqualToString:address];

    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:@{ @"Content-Type": @"application/json" }];
    }];
}

+ (void)stubRequestsMatchingAddress:(NSString *)address returningJSONWithObject:(id)object
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:address];

    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:@{ @"Content-Type": @"application/json" }];
    }];
}

+ (void)stubRequestsMatchingRequest:(NSURLRequest *)matchingRequest returningJSONWithObject:(id)object
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [matchingRequest.URL isEqual:request.URL];

    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:@{ @"Content-Type": @"application/json" }];
    }];
}

+ (void)stubRequestsMatchingAddressReturningRandomImage:(NSString *)address
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:address];

    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {;
        const NSUInteger length = 128;
        void * bytes = malloc(length);
        NSData *data = [NSData dataWithBytes:bytes length:length];
        free(bytes);
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:@{ @"Content-Type": @"image/jpg" }];
    }];
}

+ (void)stubRequestsMatchingAddress:(NSString *)address withImageAtPath:(NSString *)filepath
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:address];

    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSData *data =[NSData dataWithContentsOfFile:filepath];
        NSParameterAssert(data);
        return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:@{ @"Content-Type": @"image/jpg" }];
    }];
}


+ (void)stubRequestsMatchingAddress:(NSString *)address code:(NSInteger)code
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:address];

    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {;
        const NSUInteger length = 128;
        void * bytes = malloc(length);
        NSData *data = [NSData dataWithBytes:bytes length:length];
        free(bytes);
        return [OHHTTPStubsResponse responseWithData:data statusCode:code headers:@{ @"Content-Type": @"application/json" }];
    }];
}

@end

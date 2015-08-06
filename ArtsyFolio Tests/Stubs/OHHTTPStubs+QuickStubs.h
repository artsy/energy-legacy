
@class OHHTTPStubs;


@interface OHHTTPStubs (QuickStubs)

+ (void)stubAllRequestsReturningJSONWithObject:(id)object;
+ (void)stubRequestsMatchingRequest:(NSURLRequest *)request returningJSONWithObject:(id)object;
+ (void)stubRequestsMatchingAddress:(NSString *)address returningJSONWithObject:(id)object;
+ (void)stubRequestsMatchingAddressReturningRandomImage:(NSString *)address;
+ (void)stubRequestsMatchingAddress:(NSString *)address withImageAtPath:(NSString *)filepath;
+ (void)stubRequestsMatchingAddress:(NSString *)address code:(NSInteger)code;
+ (void)stubRequestsMatchingPath:(NSString *)address returningJSONWithObject:(id)object;

@end

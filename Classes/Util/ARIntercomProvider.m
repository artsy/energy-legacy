@import Intercom;
#import "ARIntercomProvider.h"


@implementation ARIntercomProvider

- (instancetype)initWithWithAppID:(NSString *)identifier apiKey:(NSString *)apiKey
{
    NSAssert([Intercom class], @"Intercom is not included");

    [Intercom setApiKey:apiKey forAppId:identifier];

    return [super init];
}


- (void)setUserProperty:(NSString *)property toValue:(NSString *)value
{
    [Intercom updateUserWithAttributes:@{ @"custom_attributes" : @{property : value} }];
}


@end

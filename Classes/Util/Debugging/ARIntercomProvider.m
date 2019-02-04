#import <Intercom/Intercom.h>

#import "ARIntercomProvider.h"


@implementation ARIntercomProvider

- (instancetype)initWithApiKey:(NSString *)apiKey appID:(NSString *)appID;
{
    NSAssert([Intercom class], @"Intercom is not included");

    [Intercom setApiKey:apiKey forAppId:appID];

    return [super init];
}


- (void)setUserProperty:(NSString *)property toValue:(NSString *)value
{
    ICMUserAttributes *attr = [[ICMUserAttributes alloc] init];
    attr.customAttributes = @{property : value};
    [Intercom updateUser:attr];
}


@end

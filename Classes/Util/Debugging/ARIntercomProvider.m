#import <Intercom/Intercom.h>

#import "ARIntercomProvider.h"

@implementation ARIntercomProvider

- (instancetype)initWithApiKey:(NSString *)identifier appID:(NSString *)appID;
{
    NSAssert([Intercom class], @"Intercom is not included");

    [Intercom setApiKey:identifier forAppId:appID];

    return [super init];
}


- (void)setUserProperty:(NSString *)property toValue:(NSString *)value
{
    [Intercom updateUserWithAttributes:@{ @"custom_attributes" : @{property : value} }];
}


@end

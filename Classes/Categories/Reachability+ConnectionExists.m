#import "Reachability+ConnectionExists.h"


@implementation Reachability (ConnectionExists)

+ (BOOL)connectionExists
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}

@end

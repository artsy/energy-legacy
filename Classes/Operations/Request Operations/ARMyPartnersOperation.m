#import "ARMyPartnersOperation.h"
#import "ARRouter.h"


@implementation ARMyPartnersOperation

+ (ARMyPartnersOperation *)operation
{
    NSURLRequest *request = [ARRouter newPartnersRequest];
    ARMyPartnersOperation *operation = [[ARMyPartnersOperation alloc] initWithRequest:request];
    return operation;
}

@end

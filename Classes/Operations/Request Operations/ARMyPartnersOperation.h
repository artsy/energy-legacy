#import <AFNetworking/AFJSONRequestOperation.h>

/// TBH: Not really sure why this needed to be a request operation.
///      was probably just done so to experiment with an alternative API idea.


@interface ARMyPartnersOperation : AFJSONRequestOperation
+ (ARMyPartnersOperation *)operation;
@end

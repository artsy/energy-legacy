#import "ARLoginNetworkModel.h"
#import "ARRouter.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import "ARNetworkQualityIndicator.h"


@interface ARLoginNetworkModel ()
@property (nonatomic, strong) ARNetworkQualityIndicator *quality;
@end


@implementation ARLoginNetworkModel

- (void)getUserInformation:(void (^)(id userInfo))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    NSURLRequest *infoRequest = [ARRouter newUserInfoRequest];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:infoRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) failure(request, response, error, JSON);
    }];

    [operation start];
}

- (void)getCurrentUserPartnersWithSuccess:(void (^)(id partners, ARLoginPartnerCount partnerCount))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    NSURLRequest *request = [ARRouter newPartnersRequest];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSUInteger count = [JSON count];
        ARLoginPartnerCount partnerCount;
        
        if (!count) partnerCount = ARLoginPartnerCountNone;
        else if (count == 1) partnerCount = ARLoginPartnerCountOne;
        else partnerCount = ARLoginPartnerCountMany;
        
        success(JSON, partnerCount);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) failure(request, response, error, JSON);
    }];

    [operation start];
}

- (void)getFullMetadataForPartnerWithID:(NSString *)partnerID success:(void (^)(id partnerDictionary))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    NSURLRequest *request = [ARRouter newPartnerFullInfoRequestWithID:partnerID];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) failure(request, response, error, JSON);
    }];

    [operation start];
}


- (void)pingArtsy:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;
{
    self.quality = self.quality ?: [[ARNetworkQualityIndicator alloc] init];
    [self.quality pingArtsy:completion];
}

- (void)pingApple:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;
{
    self.quality = self.quality ?: [[ARNetworkQualityIndicator alloc] init];
    [self.quality pingApple:completion];
}

@end

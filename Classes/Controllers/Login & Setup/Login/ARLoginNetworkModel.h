typedef NS_ENUM(NSInteger, ARLoginPartnerCount) {
    ARLoginPartnerCountNone,
    ARLoginPartnerCountOne,
    ARLoginPartnerCountMany
};


@interface ARLoginNetworkModel : NSObject

- (void)getUserInformation:(void (^)(id userInfo))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)getCurrentUserPartnersWithSuccess:(void (^)(id partners, ARLoginPartnerCount partnerCount))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)getFullMetadataForPartnerWithID:(NSString *)partnerID success:(void (^)(id partnerDictionary))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end

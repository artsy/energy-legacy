typedef NS_ENUM(NSInteger, ARLoginPartnerCount) {
    ARLoginPartnerCountNone,
    ARLoginPartnerCountOne,
    ARLoginPartnerCountMany,
};


@interface ARLoginNetworkModel : NSObject

/// Get the user info
- (void)getUserInformation:(void (^)(id userInfo))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

/// Get all Partners associated with the user
- (void)getCurrentUserPartnersWithSuccess:(void (^)(id partners, ARLoginPartnerCount partnerCount))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

/// Get Full Partner Metadata
- (void)getFullMetadataForPartnerWithID:(NSString *)partnerID success:(void (^)(id partnerDictionary))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

/// Is Artsy up?
- (void)pingArtsy:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;

/// Is Apple up? A pretty reliable way to check if the user is offline
- (void)pingApple:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;

@end

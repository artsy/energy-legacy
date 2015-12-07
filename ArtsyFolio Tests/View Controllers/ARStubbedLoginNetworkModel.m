#import "ARStubbedLoginNetworkModel.h"
#import "ARModelFactory.h"


@implementation ARStubbedLoginNetworkModel

- (instancetype)initWithPartnerCount:(ARLoginPartnerCount)count isAdmin:(BOOL)admin
{
    self = [super init];
    if (!self) return nil;

    self.stubbedPartnerCount = count;
    self.isAdmin = admin;

    return self;
}

- (void)getUserInformation:(void (^)(id userInfo))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    NSDictionary *userInfo;

    if (self.isAdmin) {
        userInfo = @{
            ARFeedEmailKey : @"admin@admin.com",
            ARFeedIDKey : @"stub_admin_user",
            ARFeedNameKey : @"Admin User",
            ARFeedTypeKey : @"Admin",
        };
    } else {
        userInfo = @{
            ARFeedEmailKey : @"user@normal.com",
            ARFeedIDKey : @"stub_partner_user",
            ARFeedNameKey : @"Partner User",
            ARFeedTypeKey : @"User",
        };
    }

    success(userInfo);
}

- (void)getCurrentUserPartnersWithSuccess:(void (^)(id partners, ARLoginPartnerCount partnerCount))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    if (self.stubbedPartnerCount == ARLoginPartnerCountNone)
        success(@{}, ARLoginPartnerCountNone);

    else if (self.stubbedPartnerCount == ARLoginPartnerCountOne) {
        NSArray *partnerJSON = @[
            @{ ARFeedNameKey : @"Test Partner" },
        ];
        success(partnerJSON, ARLoginPartnerCountOne);

    } else {
        NSArray *partnersJSON = @[
            @{ ARFeedNameKey : @"Test Partner 1" },
            @{ ARFeedNameKey : @"Test Partner 2" },
            @{ ARFeedNameKey : @"Test Partner 3" },
        ];
        success(partnersJSON, ARLoginPartnerCountMany);
    }
}

- (void)getFullMetadataForPartnerWithID:(NSString *)partnerID success:(void (^)(id partnerDictionary))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    NSDictionary *partnerMetadata = @{ ARFeedNameKey : @"Test Partner",
                                       ARFeedTypeKey : @"Gallery",
                                       ARFeedIDKey : @"stub_partner_id",
    };

    success(partnerMetadata);
}

- (void)pingArtsy:(void (^)(BOOL completed, NSTimeInterval time))completion
{
    completion(self.isArtsyUp, 1);
}

- (void)pingApple:(void (^)(BOOL completed, NSTimeInterval time))completion
{
    completion(self.isAppleUp, 1);
}


@end

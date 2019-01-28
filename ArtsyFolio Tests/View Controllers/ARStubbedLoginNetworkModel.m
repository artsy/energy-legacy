#import "ARStubbedLoginNetworkModel.h"
#import "ARModelFactory.h"


@implementation ARStubbedLoginNetworkModel

- (instancetype)initWithPartnerCount:(ARLoginPartnerCount)count isAdmin:(BOOL)admin lockedOutCMS:(BOOL)lockedOutCMS lockedOutFolio:(BOOL)lockedOutFolio
{
    self = [super init];
    if (!self) return nil;

    self.stubbedPartnerCount = count;
    self.isAdmin = admin;
    self.lockedOutCMS = lockedOutCMS;
    self.lockedOutFolio = lockedOutFolio;

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
    switch (self.stubbedPartnerCount) {
        case ARLoginPartnerCountNone:
            success(@{}, ARLoginPartnerCountNone);
            break;

        case ARLoginPartnerCountOne: {
            NSDictionary *partnerJSON = @{
                ARFeedNameKey : @"Test Partner",
                ARFeedHasLimitedFolioAccessKey : @(self.lockedOutFolio),
                ARFeedHasLimitedPartnerToolAccessKey : @(self.lockedOutCMS)
            };
            success(@[ partnerJSON ], ARLoginPartnerCountOne);
            break;
        }
        case ARLoginPartnerCountMany: {
            NSArray *partnersJSON = @[
                @{ ARFeedNameKey : @"Test Partner 1" },
                @{ ARFeedNameKey : @"Test Partner 2" },
                @{ ARFeedNameKey : @"Test Partner 3" },
            ];
            success(partnersJSON, ARLoginPartnerCountMany);
            break;
        }
    }
}

- (void)getFullMetadataForPartnerWithID:(NSString *)partnerID success:(void (^)(id partnerDictionary))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    NSDictionary *partnerMetadata = @{
        ARFeedNameKey : @"Test Partner",
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

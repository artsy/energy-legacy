#import "ARLoginNetworkModel.h"


@interface ARStubbedLoginNetworkModel : ARLoginNetworkModel

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, assign) ARLoginPartnerCount stubbedPartnerCount;

- (instancetype)initWithPartnerCount:(ARLoginPartnerCount)count isAdmin:(BOOL)admin;

- (void)getUserInformation:(void (^)(id userInfo))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)getCurrentUserPartnersWithSuccess:(void (^)(id partners, ARLoginPartnerCount partnerCount))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)getFullMetadataForPartnerWithID:(NSString *)partnerID success:(void (^)(id partnerDictionary))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end

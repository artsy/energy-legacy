#import "ARLoginNetworkModel.h"


@interface ARStubbedLoginNetworkModel : ARLoginNetworkModel

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, assign) ARLoginPartnerCount stubbedPartnerCount;

@property (nonatomic, copy) NSDictionary *loginErrorDict;
@property (nonatomic, assign) BOOL isArtsyUp;
@property (nonatomic, assign) BOOL isAppleUp;

- (instancetype)initWithPartnerCount:(ARLoginPartnerCount)count isAdmin:(BOOL)admin;

@end

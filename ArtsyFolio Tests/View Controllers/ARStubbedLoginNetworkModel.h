#import "ARLoginNetworkModel.h"


@interface ARStubbedLoginNetworkModel : ARLoginNetworkModel

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, assign) ARLoginPartnerCount stubbedPartnerCount;

@property (nonatomic, copy) NSDictionary *loginErrorDict;
@property (nonatomic, assign) BOOL isArtsyUp;
@property (nonatomic, assign) BOOL isAppleUp;
@property (nonatomic, assign) BOOL lockedOutFolio;
@property (nonatomic, assign) BOOL lockedOutCMS;

- (instancetype)initWithPartnerCount:(ARLoginPartnerCount)count isAdmin:(BOOL)admin lockedOutCMS:(BOOL)lockedOutCMS lockedOutFolio:(BOOL)lockedOutFolio;

@end

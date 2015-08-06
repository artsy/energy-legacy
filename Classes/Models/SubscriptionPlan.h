#import "_SubscriptionPlan.h"


@interface SubscriptionPlan : _SubscriptionPlan
+ (NSArray *)stringRepresentationOfPlans:(NSSet *)plans;
+ (NSSet *)plansWithStringArray:(NSArray *)array inContext:(NSManagedObjectContext *)context;
@end

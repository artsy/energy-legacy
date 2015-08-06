#import "SubscriptionPlan.h"


@implementation SubscriptionPlan

+ (NSArray *)stringRepresentationOfPlans:(NSSet *)plans
{
    return [plans map:^id(SubscriptionPlan *plan) {
        return plan.name;
    }];
}

+ (NSSet *)plansWithStringArray:(NSArray *)array inContext:(NSManagedObjectContext *)context
{
    if (!array) return nil;

    return [NSSet setWithArray:[array map:^(NSString *object) {
        SubscriptionPlan *plan = [SubscriptionPlan createInContext:context];
        plan.name = object;
        return plan;
    }]];
}

@end

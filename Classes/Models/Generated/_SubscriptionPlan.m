// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SubscriptionPlan.m instead.

#import "_SubscriptionPlan.h"

const struct SubscriptionPlanAttributes SubscriptionPlanAttributes = {
    .name = @"name",
};

const struct SubscriptionPlanRelationships SubscriptionPlanRelationships = {
    .subscriptionForPartner = @"subscriptionForPartner",
};


@implementation SubscriptionPlanID
@end


@implementation _SubscriptionPlan

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"SubscriptionPlan" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"SubscriptionPlan";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"SubscriptionPlan" inManagedObjectContext:moc_];
}

- (SubscriptionPlanID *)objectID
{
    return (SubscriptionPlanID *)[super objectID];
}

@dynamic name;

@dynamic subscriptionForPartner;

@end

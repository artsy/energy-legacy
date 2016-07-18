// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SubscriptionPlan.m instead.

#import "_SubscriptionPlan.h"


@implementation SubscriptionPlanID
@end


@implementation _SubscriptionPlan

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@dynamic name;

@dynamic subscriptionForPartner;

@end


@implementation SubscriptionPlanAttributes
+ (NSString *)name
{
    return @"name";
}
@end


@implementation SubscriptionPlanRelationships
+ (NSString *)subscriptionForPartner
{
    return @"subscriptionForPartner";
}
@end

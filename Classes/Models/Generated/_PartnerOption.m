// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PartnerOption.m instead.

#import "_PartnerOption.h"


@implementation PartnerOptionID
@end


@implementation _PartnerOption

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"PartnerOption" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"PartnerOption";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"PartnerOption" inManagedObjectContext:moc_];
}

- (PartnerOptionID *)objectID
{
    return (PartnerOptionID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@dynamic key;

@dynamic value;

@dynamic partner;

@end


@implementation PartnerOptionAttributes
+ (NSString *)key
{
    return @"key";
}
+ (NSString *)value
{
    return @"value";
}
@end


@implementation PartnerOptionRelationships
+ (NSString *)partner
{
    return @"partner";
}
@end

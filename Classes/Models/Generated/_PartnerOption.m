// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PartnerOption.m instead.

#import "_PartnerOption.h"

const struct PartnerOptionAttributes PartnerOptionAttributes = {
    .key = @"key",
    .value = @"value",
};

const struct PartnerOptionRelationships PartnerOptionRelationships = {
    .partner = @"partner",
};

const struct PartnerOptionUserInfo PartnerOptionUserInfo = {};


@implementation PartnerOptionID
@end


@implementation _PartnerOption

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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


@dynamic key;
@dynamic value;


@dynamic partner;


@end

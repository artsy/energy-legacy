// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
    .email = @"email",
    .name = @"name",
    .slug = @"slug",
    .type = @"type",
};

const struct UserRelationships UserRelationships = {
    .adminForPartner = @"adminForPartner",
};


@implementation UserID
@end


@implementation _User

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"User";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (UserID *)objectID
{
    return (UserID *)[super objectID];
}

@dynamic email;
@dynamic name;
@dynamic slug;
@dynamic type;

@dynamic adminForPartner;

@end

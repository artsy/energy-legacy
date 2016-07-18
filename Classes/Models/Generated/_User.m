// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"


@implementation UserID
@end


@implementation _User

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    return keyPaths;
}

@dynamic email;

@dynamic name;

@dynamic slug;

@dynamic type;

@dynamic adminForPartner;

@end


@implementation UserAttributes
+ (NSString *)email
{
    return @"email";
}
+ (NSString *)name
{
    return @"name";
}
+ (NSString *)slug
{
    return @"slug";
}
+ (NSString *)type
{
    return @"type";
}
@end


@implementation UserRelationships
+ (NSString *)adminForPartner
{
    return @"adminForPartner";
}
@end

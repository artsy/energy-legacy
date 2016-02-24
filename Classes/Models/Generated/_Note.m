// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.m instead.

#import "_Note.h"

const struct NoteAttributes NoteAttributes = {
    .body = @"body",
    .createdAt = @"createdAt",
    .updatedAt = @"updatedAt",
};

const struct NoteRelationships NoteRelationships = {
    .artwork = @"artwork",
};

const struct NoteUserInfo NoteUserInfo = {};


@implementation NoteID
@end


@implementation _Note

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Note";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Note" inManagedObjectContext:moc_];
}

- (NoteID *)objectID
{
    return (NoteID *)[super objectID];
}


@dynamic body;
@dynamic createdAt;
@dynamic updatedAt;


@dynamic artwork;


@end

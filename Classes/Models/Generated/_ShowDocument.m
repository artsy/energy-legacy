// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ShowDocument.m instead.

#import "_ShowDocument.h"


@implementation ShowDocumentID
@end


@implementation _ShowDocument

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"ShowDocument" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"ShowDocument";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"ShowDocument" inManagedObjectContext:moc_];
}

- (ShowDocumentID *)objectID
{
    return (ShowDocumentID *)[super objectID];
}

@end

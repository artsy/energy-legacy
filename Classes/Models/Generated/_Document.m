// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Document.m instead.

#import "_Document.h"

const struct DocumentAttributes DocumentAttributes = {
    .filename = @"filename",
    .hasFile = @"hasFile",
    .humanReadableSize = @"humanReadableSize",
    .size = @"size",
    .slug = @"slug",
    .title = @"title",
    .url = @"url",
    .version = @"version",
};

const struct DocumentRelationships DocumentRelationships = {
    .album = @"album",
    .artist = @"artist",
    .show = @"show",
};

const struct DocumentUserInfo DocumentUserInfo = {};


@implementation DocumentID
@end


@implementation _Document

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Document";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Document" inManagedObjectContext:moc_];
}

- (DocumentID *)objectID
{
    return (DocumentID *)[super objectID];
}


@dynamic filename;
@dynamic hasFile;
@dynamic humanReadableSize;
@dynamic size;
@dynamic slug;
@dynamic title;
@dynamic url;
@dynamic version;


@dynamic album;
@dynamic artist;
@dynamic show;


@end

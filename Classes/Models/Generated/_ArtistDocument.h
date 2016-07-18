// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ArtistDocument.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "Document.h"

NS_ASSUME_NONNULL_BEGIN


@interface ArtistDocumentID : DocumentID
{
}
@end


@interface _ArtistDocument : Document
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) ArtistDocumentID *objectID;

@end


@interface _ArtistDocument (CoreDataGeneratedPrimitiveAccessors)

@end

NS_ASSUME_NONNULL_END

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ShowDocument.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "Document.h"

NS_ASSUME_NONNULL_BEGIN


@interface ShowDocumentID : DocumentID
{
}
@end


@interface _ShowDocument : Document
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) ShowDocumentID *objectID;

@end


@interface _ShowDocument (CoreDataGeneratedPrimitiveAccessors)

@end

NS_ASSUME_NONNULL_END

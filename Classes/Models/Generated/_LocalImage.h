// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LocalImage.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "Image.h"

NS_ASSUME_NONNULL_BEGIN


@interface LocalImageID : ImageID
{
}
@end


@interface _LocalImage : Image
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) LocalImageID *objectID;

@end


@interface _LocalImage (CoreDataGeneratedPrimitiveAccessors)

@end

NS_ASSUME_NONNULL_END

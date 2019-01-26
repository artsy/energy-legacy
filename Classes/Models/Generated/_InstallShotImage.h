// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to InstallShotImage.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@class Show;


@interface InstallShotImageID : ImageID
{
}
@end


@interface _InstallShotImage : Image
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) InstallShotImageID *objectID;

@property (nonatomic, strong, nullable) NSString *caption;

@property (nonatomic, strong, nullable) Show *showWithImageInInstallation;

@end


@interface _InstallShotImage (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString *)primitiveCaption;
- (void)setPrimitiveCaption:(nullable NSString *)value;

- (Show *)primitiveShowWithImageInInstallation;
- (void)setPrimitiveShowWithImageInInstallation:(Show *)value;

@end


@interface InstallShotImageAttributes : NSObject
+ (NSString *)caption;
@end


@interface InstallShotImageRelationships : NSObject
+ (NSString *)showWithImageInInstallation;
@end

NS_ASSUME_NONNULL_END

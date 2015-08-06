// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to InstallShotImage.h instead.

#import <CoreData/CoreData.h>
#import "Image.h"

extern const struct InstallShotImageAttributes {
    __unsafe_unretained NSString *caption;
} InstallShotImageAttributes;

extern const struct InstallShotImageRelationships {
    __unsafe_unretained NSString *showWithImageInInstallation;
} InstallShotImageRelationships;

@class Show;


@interface InstallShotImageID : ImageID {
}
@end


@interface _InstallShotImage : Image {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (InstallShotImageID *)objectID;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) Show *showWithImageInInstallation;

@end


@interface _InstallShotImage (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveCaption;

- (void)setPrimitiveCaption:(NSString *)value;

- (Show *)primitiveShowWithImageInInstallation;

- (void)setPrimitiveShowWithImageInInstallation:(Show *)value;

@end

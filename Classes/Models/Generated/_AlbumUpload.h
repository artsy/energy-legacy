// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumUpload.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"
extern const struct AlbumUploadAttributes {
    __unsafe_unretained NSString *createdAt;
} AlbumUploadAttributes;

extern const struct AlbumUploadRelationships {
    __unsafe_unretained NSString *album;
} AlbumUploadRelationships;

@class Album;


@interface AlbumUploadID : NSManagedObjectID {
}
@end


@interface _AlbumUpload : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (AlbumUploadID *)objectID;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) Album *album;

@end


@interface _AlbumUpload (CoreDataGeneratedPrimitiveAccessors)

- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;

- (Album *)primitiveAlbum;
- (void)setPrimitiveAlbum:(Album *)value;

@end

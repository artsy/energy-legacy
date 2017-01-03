// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumDelete.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"
extern const struct AlbumDeleteAttributes {
    __unsafe_unretained NSString *albumID;
    __unsafe_unretained NSString *createdAt;
} AlbumDeleteAttributes;


@interface AlbumDeleteID : NSManagedObjectID
{
}
@end


@interface _AlbumDelete : ARManagedObject
{
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (AlbumDeleteID *)objectID;

@property (nonatomic, strong) NSString *albumID;
@property (nonatomic, strong) NSDate *createdAt;

@end


@interface _AlbumDelete (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveAlbumID;
- (void)setPrimitiveAlbumID:(NSString *)value;

- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;

@end

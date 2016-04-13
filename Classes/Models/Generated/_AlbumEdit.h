// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumEdit.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"
extern const struct AlbumEditAttributes {
    __unsafe_unretained NSString *albumWasCreated;
    __unsafe_unretained NSString *createdAt;
} AlbumEditAttributes;

extern const struct AlbumEditRelationships {
    __unsafe_unretained NSString *addedArtworks;
    __unsafe_unretained NSString *album;
    __unsafe_unretained NSString *removedArtworks;
} AlbumEditRelationships;

@class Artwork;
@class Album;
@class Artwork;


@interface AlbumEditID : NSManagedObjectID {
}
@end


@interface _AlbumEdit : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (AlbumEditID *)objectID;

@property (nonatomic, strong) NSNumber *albumWasCreated;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSSet *addedArtworks;
- (NSMutableSet *)addedArtworksSet;
@property (nonatomic, strong) Album *album;

@property (nonatomic, strong) NSSet *removedArtworks;
- (NSMutableSet *)removedArtworksSet;

@end


@interface _AlbumEdit (AddedArtworksCoreDataGeneratedAccessors)
- (void)addAddedArtworks:(NSSet *)value_;
- (void)removeAddedArtworks:(NSSet *)value_;
- (void)addAddedArtworksObject:(Artwork *)value_;
- (void)removeAddedArtworksObject:(Artwork *)value_;
@end


@interface _AlbumEdit (RemovedArtworksCoreDataGeneratedAccessors)
- (void)addRemovedArtworks:(NSSet *)value_;
- (void)removeRemovedArtworks:(NSSet *)value_;
- (void)addRemovedArtworksObject:(Artwork *)value_;
- (void)removeRemovedArtworksObject:(Artwork *)value_;
@end


@interface _AlbumEdit (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveAlbumWasCreated;
- (void)setPrimitiveAlbumWasCreated:(NSNumber *)value;

- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;

- (NSMutableSet *)primitiveAddedArtworks;
- (void)setPrimitiveAddedArtworks:(NSMutableSet *)value;

- (Album *)primitiveAlbum;
- (void)setPrimitiveAlbum:(Album *)value;

- (NSMutableSet *)primitiveRemovedArtworks;
- (void)setPrimitiveRemovedArtworks:(NSMutableSet *)value;

@end

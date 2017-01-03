// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumEdit.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "ARManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class Artwork;
@class Album;
@class Artwork;


@interface AlbumEditID : NSManagedObjectID
{
}
@end


@interface _AlbumEdit : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) AlbumEditID *objectID;

@property (nonatomic, strong, nullable) NSNumber *albumWasCreated;

@property (atomic) BOOL albumWasCreatedValue;
- (BOOL)albumWasCreatedValue;
- (void)setAlbumWasCreatedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSDate *createdAt;

@property (nonatomic, strong, nullable) NSSet<Artwork *> *addedArtworks;
- (nullable NSMutableSet<Artwork *> *)addedArtworksSet;

@property (nonatomic, strong, nullable) Album *album;

@property (nonatomic, strong, nullable) NSSet<Artwork *> *removedArtworks;
- (nullable NSMutableSet<Artwork *> *)removedArtworksSet;

@end


@interface _AlbumEdit (AddedArtworksCoreDataGeneratedAccessors)
- (void)addAddedArtworks:(NSSet<Artwork *> *)value_;
- (void)removeAddedArtworks:(NSSet<Artwork *> *)value_;
- (void)addAddedArtworksObject:(Artwork *)value_;
- (void)removeAddedArtworksObject:(Artwork *)value_;

@end


@interface _AlbumEdit (RemovedArtworksCoreDataGeneratedAccessors)
- (void)addRemovedArtworks:(NSSet<Artwork *> *)value_;
- (void)removeRemovedArtworks:(NSSet<Artwork *> *)value_;
- (void)addRemovedArtworksObject:(Artwork *)value_;
- (void)removeRemovedArtworksObject:(Artwork *)value_;

@end


@interface _AlbumEdit (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveAlbumWasCreated;
- (void)setPrimitiveAlbumWasCreated:(NSNumber *)value;

- (BOOL)primitiveAlbumWasCreatedValue;
- (void)setPrimitiveAlbumWasCreatedValue:(BOOL)value_;

- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;

- (NSMutableSet<Artwork *> *)primitiveAddedArtworks;
- (void)setPrimitiveAddedArtworks:(NSMutableSet<Artwork *> *)value;

- (Album *)primitiveAlbum;
- (void)setPrimitiveAlbum:(Album *)value;

- (NSMutableSet<Artwork *> *)primitiveRemovedArtworks;
- (void)setPrimitiveRemovedArtworks:(NSMutableSet<Artwork *> *)value;

@end


@interface AlbumEditAttributes : NSObject
+ (NSString *)albumWasCreated;
+ (NSString *)createdAt;
@end


@interface AlbumEditRelationships : NSObject
+ (NSString *)addedArtworks;
+ (NSString *)album;
+ (NSString *)removedArtworks;
@end

NS_ASSUME_NONNULL_END

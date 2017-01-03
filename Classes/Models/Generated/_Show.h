// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Show.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "ARManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class Artist;
@class Artwork;
@class Image;
@class Document;
@class InstallShotImage;
@class Location;


@interface ShowID : NSManagedObjectID
{
}
@end


@interface _Show : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) ShowID *objectID;

@property (nonatomic, strong, nullable) NSString *availabilityPeriod;

@property (nonatomic, strong, nullable) NSString *createdAt;

@property (nonatomic, strong, nullable) NSDate *endsAt;

@property (nonatomic, strong, nullable) NSString *name;

@property (nonatomic, strong, nullable) NSString *showSlug;

@property (nonatomic, strong) NSString *slug;

@property (nonatomic, strong, nullable) NSNumber *sortKey;

@property (atomic) int16_t sortKeyValue;
- (int16_t)sortKeyValue;
- (void)setSortKeyValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSDate *startsAt;

@property (nonatomic, strong, nullable) NSString *status;

@property (nonatomic, strong, nullable) NSDate *updatedAt;

@property (nonatomic, strong, nullable) NSSet<Artist *> *artists;
- (nullable NSMutableSet<Artist *> *)artistsSet;

@property (nonatomic, strong, nullable) NSSet<Artwork *> *artworks;
- (nullable NSMutableSet<Artwork *> *)artworksSet;

@property (nonatomic, strong, nullable) Image *cover;

@property (nonatomic, strong, nullable) NSSet<Document *> *documents;
- (nullable NSMutableSet<Document *> *)documentsSet;

@property (nonatomic, strong, nullable) NSSet<InstallShotImage *> *installationImages;
- (nullable NSMutableSet<InstallShotImage *> *)installationImagesSet;

@property (nonatomic, strong, nullable) Location *location;

@end


@interface _Show (ArtistsCoreDataGeneratedAccessors)
- (void)addArtists:(NSSet<Artist *> *)value_;
- (void)removeArtists:(NSSet<Artist *> *)value_;
- (void)addArtistsObject:(Artist *)value_;
- (void)removeArtistsObject:(Artist *)value_;

@end


@interface _Show (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet<Artwork *> *)value_;
- (void)removeArtworks:(NSSet<Artwork *> *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;

@end


@interface _Show (DocumentsCoreDataGeneratedAccessors)
- (void)addDocuments:(NSSet<Document *> *)value_;
- (void)removeDocuments:(NSSet<Document *> *)value_;
- (void)addDocumentsObject:(Document *)value_;
- (void)removeDocumentsObject:(Document *)value_;

@end


@interface _Show (InstallationImagesCoreDataGeneratedAccessors)
- (void)addInstallationImages:(NSSet<InstallShotImage *> *)value_;
- (void)removeInstallationImages:(NSSet<InstallShotImage *> *)value_;
- (void)addInstallationImagesObject:(InstallShotImage *)value_;
- (void)removeInstallationImagesObject:(InstallShotImage *)value_;

@end


@interface _Show (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveAvailabilityPeriod;
- (void)setPrimitiveAvailabilityPeriod:(NSString *)value;

- (NSString *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSString *)value;

- (NSDate *)primitiveEndsAt;
- (void)setPrimitiveEndsAt:(NSDate *)value;

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

- (NSString *)primitiveShowSlug;
- (void)setPrimitiveShowSlug:(NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (NSNumber *)primitiveSortKey;
- (void)setPrimitiveSortKey:(NSNumber *)value;

- (int16_t)primitiveSortKeyValue;
- (void)setPrimitiveSortKeyValue:(int16_t)value_;

- (NSDate *)primitiveStartsAt;
- (void)setPrimitiveStartsAt:(NSDate *)value;

- (NSString *)primitiveStatus;
- (void)setPrimitiveStatus:(NSString *)value;

- (NSDate *)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate *)value;

- (NSMutableSet<Artist *> *)primitiveArtists;
- (void)setPrimitiveArtists:(NSMutableSet<Artist *> *)value;

- (NSMutableSet<Artwork *> *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet<Artwork *> *)value;

- (Image *)primitiveCover;
- (void)setPrimitiveCover:(Image *)value;

- (NSMutableSet<Document *> *)primitiveDocuments;
- (void)setPrimitiveDocuments:(NSMutableSet<Document *> *)value;

- (NSMutableSet<InstallShotImage *> *)primitiveInstallationImages;
- (void)setPrimitiveInstallationImages:(NSMutableSet<InstallShotImage *> *)value;

- (Location *)primitiveLocation;
- (void)setPrimitiveLocation:(Location *)value;

@end


@interface ShowAttributes : NSObject
+ (NSString *)availabilityPeriod;
+ (NSString *)createdAt;
+ (NSString *)endsAt;
+ (NSString *)name;
+ (NSString *)showSlug;
+ (NSString *)slug;
+ (NSString *)sortKey;
+ (NSString *)startsAt;
+ (NSString *)status;
+ (NSString *)updatedAt;
@end


@interface ShowRelationships : NSObject
+ (NSString *)artists;
+ (NSString *)artworks;
+ (NSString *)cover;
+ (NSString *)documents;
+ (NSString *)installationImages;
+ (NSString *)location;
@end

NS_ASSUME_NONNULL_END

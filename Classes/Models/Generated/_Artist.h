// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Artist.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "ARManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class Album;
@class Artwork;
@class Image;
@class Document;
@class Image;
@class Show;


@interface ArtistID : NSManagedObjectID
{
}
@end


@interface _Artist : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) ArtistID *objectID;

@property (nonatomic, strong, nullable) NSString *awards;

@property (nonatomic, strong, nullable) NSString *biography;

@property (nonatomic, strong, nullable) NSString *blurb;

@property (nonatomic, strong, nullable) NSDate *createdAt;

@property (nonatomic, strong, nullable) NSDate *deathDate;

@property (nonatomic, strong, nullable) NSString *displayName;

@property (nonatomic, strong, nullable) NSString *firstName;

@property (nonatomic, strong, nullable) NSString *hometown;

@property (nonatomic, strong, nullable) NSString *lastName;

@property (nonatomic, strong, nullable) NSString *middleName;

@property (nonatomic, strong, nullable) NSString *name;

@property (nonatomic, strong, nullable) NSString *nationality;

@property (nonatomic, strong, nullable) NSString *orderingKey;

@property (nonatomic, strong) NSString *slug;

@property (nonatomic, strong, nullable) NSString *statement;

@property (nonatomic, strong, nullable) NSString *thumbnailBaseURL;

@property (nonatomic, strong, nullable) NSDate *updatedAt;

@property (nonatomic, strong, nullable) NSString *years;

@property (nonatomic, strong, nullable) NSSet<Album *> *albumsFeaturingArtist;
- (nullable NSMutableSet<Album *> *)albumsFeaturingArtistSet;

@property (nonatomic, strong, nullable) NSSet<Artwork *> *artworks;
- (nullable NSMutableSet<Artwork *> *)artworksSet;

@property (nonatomic, strong, nullable) Image *cover;

@property (nonatomic, strong, nullable) NSSet<Document *> *documents;
- (nullable NSMutableSet<Document *> *)documentsSet;

@property (nonatomic, strong, nullable) Image *installShotsFeaturingArtist;

@property (nonatomic, strong, nullable) NSSet<Show *> *showsFeaturingArtist;
- (nullable NSMutableSet<Show *> *)showsFeaturingArtistSet;

@end


@interface _Artist (AlbumsFeaturingArtistCoreDataGeneratedAccessors)
- (void)addAlbumsFeaturingArtist:(NSSet<Album *> *)value_;
- (void)removeAlbumsFeaturingArtist:(NSSet<Album *> *)value_;
- (void)addAlbumsFeaturingArtistObject:(Album *)value_;
- (void)removeAlbumsFeaturingArtistObject:(Album *)value_;

@end


@interface _Artist (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet<Artwork *> *)value_;
- (void)removeArtworks:(NSSet<Artwork *> *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;

@end


@interface _Artist (DocumentsCoreDataGeneratedAccessors)
- (void)addDocuments:(NSSet<Document *> *)value_;
- (void)removeDocuments:(NSSet<Document *> *)value_;
- (void)addDocumentsObject:(Document *)value_;
- (void)removeDocumentsObject:(Document *)value_;

@end


@interface _Artist (ShowsFeaturingArtistCoreDataGeneratedAccessors)
- (void)addShowsFeaturingArtist:(NSSet<Show *> *)value_;
- (void)removeShowsFeaturingArtist:(NSSet<Show *> *)value_;
- (void)addShowsFeaturingArtistObject:(Show *)value_;
- (void)removeShowsFeaturingArtistObject:(Show *)value_;

@end


@interface _Artist (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString *)primitiveAwards;
- (void)setPrimitiveAwards:(nullable NSString *)value;

- (nullable NSString *)primitiveBiography;
- (void)setPrimitiveBiography:(nullable NSString *)value;

- (nullable NSString *)primitiveBlurb;
- (void)setPrimitiveBlurb:(nullable NSString *)value;

- (nullable NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(nullable NSDate *)value;

- (nullable NSDate *)primitiveDeathDate;
- (void)setPrimitiveDeathDate:(nullable NSDate *)value;

- (nullable NSString *)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(nullable NSString *)value;

- (nullable NSString *)primitiveFirstName;
- (void)setPrimitiveFirstName:(nullable NSString *)value;

- (nullable NSString *)primitiveHometown;
- (void)setPrimitiveHometown:(nullable NSString *)value;

- (nullable NSString *)primitiveLastName;
- (void)setPrimitiveLastName:(nullable NSString *)value;

- (nullable NSString *)primitiveMiddleName;
- (void)setPrimitiveMiddleName:(nullable NSString *)value;

- (nullable NSString *)primitiveName;
- (void)setPrimitiveName:(nullable NSString *)value;

- (nullable NSString *)primitiveNationality;
- (void)setPrimitiveNationality:(nullable NSString *)value;

- (nullable NSString *)primitiveOrderingKey;
- (void)setPrimitiveOrderingKey:(nullable NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (nullable NSString *)primitiveStatement;
- (void)setPrimitiveStatement:(nullable NSString *)value;

- (nullable NSString *)primitiveThumbnailBaseURL;
- (void)setPrimitiveThumbnailBaseURL:(nullable NSString *)value;

- (nullable NSDate *)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(nullable NSDate *)value;

- (nullable NSString *)primitiveYears;
- (void)setPrimitiveYears:(nullable NSString *)value;

- (NSMutableSet<Album *> *)primitiveAlbumsFeaturingArtist;
- (void)setPrimitiveAlbumsFeaturingArtist:(NSMutableSet<Album *> *)value;

- (NSMutableSet<Artwork *> *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet<Artwork *> *)value;

- (Image *)primitiveCover;
- (void)setPrimitiveCover:(Image *)value;

- (NSMutableSet<Document *> *)primitiveDocuments;
- (void)setPrimitiveDocuments:(NSMutableSet<Document *> *)value;

- (Image *)primitiveInstallShotsFeaturingArtist;
- (void)setPrimitiveInstallShotsFeaturingArtist:(Image *)value;

- (NSMutableSet<Show *> *)primitiveShowsFeaturingArtist;
- (void)setPrimitiveShowsFeaturingArtist:(NSMutableSet<Show *> *)value;

@end


@interface ArtistAttributes : NSObject
+ (NSString *)awards;
+ (NSString *)biography;
+ (NSString *)blurb;
+ (NSString *)createdAt;
+ (NSString *)deathDate;
+ (NSString *)displayName;
+ (NSString *)firstName;
+ (NSString *)hometown;
+ (NSString *)lastName;
+ (NSString *)middleName;
+ (NSString *)name;
+ (NSString *)nationality;
+ (NSString *)orderingKey;
+ (NSString *)slug;
+ (NSString *)statement;
+ (NSString *)thumbnailBaseURL;
+ (NSString *)updatedAt;
+ (NSString *)years;
@end


@interface ArtistRelationships : NSObject
+ (NSString *)albumsFeaturingArtist;
+ (NSString *)artworks;
+ (NSString *)cover;
+ (NSString *)documents;
+ (NSString *)installShotsFeaturingArtist;
+ (NSString *)showsFeaturingArtist;
@end

NS_ASSUME_NONNULL_END

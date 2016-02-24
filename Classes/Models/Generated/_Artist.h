// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Artist.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct ArtistAttributes {
    __unsafe_unretained NSString *awards;
    __unsafe_unretained NSString *biography;
    __unsafe_unretained NSString *blurb;
    __unsafe_unretained NSString *createdAt;
    __unsafe_unretained NSString *deathDate;
    __unsafe_unretained NSString *displayName;
    __unsafe_unretained NSString *firstName;
    __unsafe_unretained NSString *hometown;
    __unsafe_unretained NSString *lastName;
    __unsafe_unretained NSString *middleName;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *nationality;
    __unsafe_unretained NSString *orderingKey;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *statement;
    __unsafe_unretained NSString *thumbnailBaseURL;
    __unsafe_unretained NSString *updatedAt;
    __unsafe_unretained NSString *years;
} ArtistAttributes;

extern const struct ArtistRelationships {
    __unsafe_unretained NSString *albumsFeaturingArtist;
    __unsafe_unretained NSString *artworks;
    __unsafe_unretained NSString *cover;
    __unsafe_unretained NSString *documents;
    __unsafe_unretained NSString *installShotsFeaturingArtist;
    __unsafe_unretained NSString *showsFeaturingArtist;
} ArtistRelationships;

extern const struct ArtistUserInfo {
} ArtistUserInfo;

@class Album;
@class Artwork;
@class Image;
@class Document;
@class Image;
@class Show;


@interface ArtistID : ARManagedObjectID {
}
@end


@interface _Artist : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (ArtistID *)objectID;

@property (nonatomic, strong) NSString *awards;
@property (nonatomic, strong) NSString *biography;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *deathDate;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *hometown;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nationality;
@property (nonatomic, strong) NSString *orderingKey;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *statement;
@property (nonatomic, strong) NSString *thumbnailBaseURL;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *years;

@property (nonatomic, strong) NSSet *albumsFeaturingArtist;
- (NSMutableSet *)albumsFeaturingArtistSet;

@property (nonatomic, strong) NSSet *artworks;
- (NSMutableSet *)artworksSet;
@property (nonatomic, strong) Image *cover;

@property (nonatomic, strong) NSSet *documents;
- (NSMutableSet *)documentsSet;
@property (nonatomic, strong) Image *installShotsFeaturingArtist;

@property (nonatomic, strong) NSSet *showsFeaturingArtist;
- (NSMutableSet *)showsFeaturingArtistSet;


@end


@interface _Artist (AlbumsFeaturingArtistCoreDataGeneratedAccessors)
- (void)addAlbumsFeaturingArtist:(NSSet *)value_;
- (void)removeAlbumsFeaturingArtist:(NSSet *)value_;
- (void)addAlbumsFeaturingArtistObject:(Album *)value_;
- (void)removeAlbumsFeaturingArtistObject:(Album *)value_;
@end


@interface _Artist (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet *)value_;
- (void)removeArtworks:(NSSet *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;
@end


@interface _Artist (DocumentsCoreDataGeneratedAccessors)
- (void)addDocuments:(NSSet *)value_;
- (void)removeDocuments:(NSSet *)value_;
- (void)addDocumentsObject:(Document *)value_;
- (void)removeDocumentsObject:(Document *)value_;
@end


@interface _Artist (ShowsFeaturingArtistCoreDataGeneratedAccessors)
- (void)addShowsFeaturingArtist:(NSSet *)value_;
- (void)removeShowsFeaturingArtist:(NSSet *)value_;
- (void)addShowsFeaturingArtistObject:(Show *)value_;
- (void)removeShowsFeaturingArtistObject:(Show *)value_;
@end


@interface _Artist (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet *)primitiveAlbumsFeaturingArtist;
- (void)setPrimitiveAlbumsFeaturingArtist:(NSMutableSet *)value;

- (NSMutableSet *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet *)value;

- (Image *)primitiveCover;
- (void)setPrimitiveCover:(Image *)value;

- (NSMutableSet *)primitiveDocuments;
- (void)setPrimitiveDocuments:(NSMutableSet *)value;

- (Image *)primitiveInstallShotsFeaturingArtist;
- (void)setPrimitiveInstallShotsFeaturingArtist:(Image *)value;

- (NSMutableSet *)primitiveShowsFeaturingArtist;
- (void)setPrimitiveShowsFeaturingArtist:(NSMutableSet *)value;

@end

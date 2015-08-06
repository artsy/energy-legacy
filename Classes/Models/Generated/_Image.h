// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct ImageAttributes {
    __unsafe_unretained NSString *aspectRatio;
    __unsafe_unretained NSString *baseURL;
    __unsafe_unretained NSString *isMainImage;
    __unsafe_unretained NSString *maxTiledHeight;
    __unsafe_unretained NSString *maxTiledWidth;
    __unsafe_unretained NSString *originalHeight;
    __unsafe_unretained NSString *originalWidth;
    __unsafe_unretained NSString *position;
    __unsafe_unretained NSString *processing;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *tileBaseUrl;
    __unsafe_unretained NSString *tileFormat;
    __unsafe_unretained NSString *tileOverlap;
    __unsafe_unretained NSString *tileSize;
} ImageAttributes;

extern const struct ImageRelationships {
    __unsafe_unretained NSString *artistsInImage;
    __unsafe_unretained NSString *artwork;
    __unsafe_unretained NSString *artworksInImage;
    __unsafe_unretained NSString *coverForAlbum;
    __unsafe_unretained NSString *coverForArtist;
    __unsafe_unretained NSString *coverForShow;
    __unsafe_unretained NSString *mainImageForArtwork;
} ImageRelationships;

@class Artist;
@class Artwork;
@class Artwork;
@class Album;
@class Artist;
@class Show;
@class Artwork;


@interface ImageID : NSManagedObjectID {
}
@end


@interface _Image : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (ImageID *)objectID;

@property (nonatomic, strong) NSNumber *aspectRatio;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSNumber *isMainImage;
@property (nonatomic, strong) NSNumber *maxTiledHeight;
@property (nonatomic, strong) NSNumber *maxTiledWidth;
@property (nonatomic, strong) NSNumber *originalHeight;
@property (nonatomic, strong) NSNumber *originalWidth;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) NSNumber *processing;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *tileBaseUrl;
@property (nonatomic, strong) NSString *tileFormat;
@property (nonatomic, strong) NSNumber *tileOverlap;
@property (nonatomic, strong) NSNumber *tileSize;
@property (nonatomic, strong) Artist *artistsInImage;
@property (nonatomic, strong) Artwork *artwork;
@property (nonatomic, strong) Artwork *artworksInImage;
@property (nonatomic, strong) Album *coverForAlbum;
@property (nonatomic, strong) Artist *coverForArtist;
@property (nonatomic, strong) Show *coverForShow;
@property (nonatomic, strong) Artwork *mainImageForArtwork;

@end


@interface _Image (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveAspectRatio;

- (void)setPrimitiveAspectRatio:(NSNumber *)value;

- (NSString *)primitiveBaseURL;

- (void)setPrimitiveBaseURL:(NSString *)value;

- (NSNumber *)primitiveIsMainImage;

- (void)setPrimitiveIsMainImage:(NSNumber *)value;

- (NSNumber *)primitiveMaxTiledHeight;

- (void)setPrimitiveMaxTiledHeight:(NSNumber *)value;

- (NSNumber *)primitiveMaxTiledWidth;

- (void)setPrimitiveMaxTiledWidth:(NSNumber *)value;

- (NSNumber *)primitiveOriginalHeight;

- (void)setPrimitiveOriginalHeight:(NSNumber *)value;

- (NSNumber *)primitiveOriginalWidth;

- (void)setPrimitiveOriginalWidth:(NSNumber *)value;

- (NSNumber *)primitivePosition;

- (void)setPrimitivePosition:(NSNumber *)value;

- (NSNumber *)primitiveProcessing;

- (void)setPrimitiveProcessing:(NSNumber *)value;

- (NSString *)primitiveSlug;

- (void)setPrimitiveSlug:(NSString *)value;

- (NSString *)primitiveTileBaseUrl;

- (void)setPrimitiveTileBaseUrl:(NSString *)value;

- (NSString *)primitiveTileFormat;

- (void)setPrimitiveTileFormat:(NSString *)value;

- (NSNumber *)primitiveTileOverlap;

- (void)setPrimitiveTileOverlap:(NSNumber *)value;

- (NSNumber *)primitiveTileSize;

- (void)setPrimitiveTileSize:(NSNumber *)value;

- (Artist *)primitiveArtistsInImage;

- (void)setPrimitiveArtistsInImage:(Artist *)value;

- (Artwork *)primitiveArtwork;

- (void)setPrimitiveArtwork:(Artwork *)value;

- (Artwork *)primitiveArtworksInImage;

- (void)setPrimitiveArtworksInImage:(Artwork *)value;

- (Album *)primitiveCoverForAlbum;

- (void)setPrimitiveCoverForAlbum:(Album *)value;

- (Artist *)primitiveCoverForArtist;

- (void)setPrimitiveCoverForArtist:(Artist *)value;

- (Show *)primitiveCoverForShow;

- (void)setPrimitiveCoverForShow:(Show *)value;

- (Artwork *)primitiveMainImageForArtwork;

- (void)setPrimitiveMainImageForArtwork:(Artwork *)value;

@end

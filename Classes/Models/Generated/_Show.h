// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Show.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct ShowAttributes {
    __unsafe_unretained NSString *availabilityPeriod;
    __unsafe_unretained NSString *createdAt;
    __unsafe_unretained NSString *endsAt;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *showSlug;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *sortKey;
    __unsafe_unretained NSString *startsAt;
    __unsafe_unretained NSString *status;
    __unsafe_unretained NSString *updatedAt;
} ShowAttributes;

extern const struct ShowRelationships {
    __unsafe_unretained NSString *artists;
    __unsafe_unretained NSString *artworks;
    __unsafe_unretained NSString *cover;
    __unsafe_unretained NSString *documents;
    __unsafe_unretained NSString *installationImages;
    __unsafe_unretained NSString *location;
} ShowRelationships;

extern const struct ShowUserInfo {
} ShowUserInfo;

@class Artist;
@class Artwork;
@class Image;
@class Document;
@class InstallShotImage;
@class Location;


@interface ShowID : ARManagedObjectID {
}
@end


@interface _Show : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (ShowID *)objectID;

@property (nonatomic, strong) NSString *availabilityPeriod;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSDate *endsAt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *showSlug;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSNumber *sortKey;
@property (nonatomic, strong) NSDate *startsAt;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) NSSet *artists;
- (NSMutableSet *)artistsSet;

@property (nonatomic, strong) NSSet *artworks;
- (NSMutableSet *)artworksSet;
@property (nonatomic, strong) Image *cover;

@property (nonatomic, strong) NSSet *documents;
- (NSMutableSet *)documentsSet;

@property (nonatomic, strong) NSSet *installationImages;
- (NSMutableSet *)installationImagesSet;
@property (nonatomic, strong) Location *location;


@end


@interface _Show (ArtistsCoreDataGeneratedAccessors)
- (void)addArtists:(NSSet *)value_;
- (void)removeArtists:(NSSet *)value_;
- (void)addArtistsObject:(Artist *)value_;
- (void)removeArtistsObject:(Artist *)value_;
@end


@interface _Show (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet *)value_;
- (void)removeArtworks:(NSSet *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;
@end


@interface _Show (DocumentsCoreDataGeneratedAccessors)
- (void)addDocuments:(NSSet *)value_;
- (void)removeDocuments:(NSSet *)value_;
- (void)addDocumentsObject:(Document *)value_;
- (void)removeDocumentsObject:(Document *)value_;
@end


@interface _Show (InstallationImagesCoreDataGeneratedAccessors)
- (void)addInstallationImages:(NSSet *)value_;
- (void)removeInstallationImages:(NSSet *)value_;
- (void)addInstallationImagesObject:(InstallShotImage *)value_;
- (void)removeInstallationImagesObject:(InstallShotImage *)value_;
@end


@interface _Show (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet *)primitiveArtists;
- (void)setPrimitiveArtists:(NSMutableSet *)value;

- (NSMutableSet *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet *)value;

- (Image *)primitiveCover;
- (void)setPrimitiveCover:(Image *)value;

- (NSMutableSet *)primitiveDocuments;
- (void)setPrimitiveDocuments:(NSMutableSet *)value;

- (NSMutableSet *)primitiveInstallationImages;
- (void)setPrimitiveInstallationImages:(NSMutableSet *)value;

- (Location *)primitiveLocation;
- (void)setPrimitiveLocation:(Location *)value;

@end

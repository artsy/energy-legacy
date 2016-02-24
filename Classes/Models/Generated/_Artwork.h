// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Artwork.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct ArtworkAttributes {
    __unsafe_unretained NSString *availability;
    __unsafe_unretained NSString *backendPrice;
    __unsafe_unretained NSString *category;
    __unsafe_unretained NSString *confidentialNotes;
    __unsafe_unretained NSString *createdAt;
    __unsafe_unretained NSString *date;
    __unsafe_unretained NSString *depth;
    __unsafe_unretained NSString *diameter;
    __unsafe_unretained NSString *dimensionsCM;
    __unsafe_unretained NSString *dimensionsInches;
    __unsafe_unretained NSString *displayPrice;
    __unsafe_unretained NSString *displayTitle;
    __unsafe_unretained NSString *editions;
    __unsafe_unretained NSString *exhibitionHistory;
    __unsafe_unretained NSString *height;
    __unsafe_unretained NSString *imageRights;
    __unsafe_unretained NSString *info;
    __unsafe_unretained NSString *inventoryID;
    __unsafe_unretained NSString *isAvailableForSale;
    __unsafe_unretained NSString *isPriceHidden;
    __unsafe_unretained NSString *isPublished;
    __unsafe_unretained NSString *literature;
    __unsafe_unretained NSString *medium;
    __unsafe_unretained NSString *provenance;
    __unsafe_unretained NSString *series;
    __unsafe_unretained NSString *signature;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *title;
    __unsafe_unretained NSString *updatedAt;
    __unsafe_unretained NSString *width;
} ArtworkAttributes;

extern const struct ArtworkRelationships {
    __unsafe_unretained NSString *artist;
    __unsafe_unretained NSString *collections;
    __unsafe_unretained NSString *editionSets;
    __unsafe_unretained NSString *images;
    __unsafe_unretained NSString *installShotsFeaturingArtwork;
    __unsafe_unretained NSString *locations;
    __unsafe_unretained NSString *mainImage;
    __unsafe_unretained NSString *notes;
    __unsafe_unretained NSString *partner;
    __unsafe_unretained NSString *shows;
} ArtworkRelationships;

extern const struct ArtworkUserInfo {
} ArtworkUserInfo;

@class Artist;
@class Album;
@class EditionSet;
@class Image;
@class Image;
@class Location;
@class Image;
@class Note;
@class Partner;
@class Show;


@interface ArtworkID : ARManagedObjectID {
}
@end


@interface _Artwork : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (ArtworkID *)objectID;

@property (nonatomic, strong) NSString *availability;
@property (nonatomic, strong) NSString *backendPrice;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *confidentialNotes;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSDecimalNumber *depth;
@property (nonatomic, strong) NSDecimalNumber *diameter;
@property (nonatomic, strong) NSString *dimensionsCM;
@property (nonatomic, strong) NSString *dimensionsInches;
@property (nonatomic, strong) NSString *displayPrice;
@property (nonatomic, strong) NSString *displayTitle;
@property (nonatomic, strong) NSString *editions;
@property (nonatomic, strong) NSString *exhibitionHistory;
@property (nonatomic, strong) NSDecimalNumber *height;
@property (nonatomic, strong) NSString *imageRights;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *inventoryID;
@property (nonatomic, strong) NSNumber *isAvailableForSale;
@property (nonatomic, strong) NSNumber *isPriceHidden;
@property (nonatomic, strong) NSNumber *isPublished;
@property (nonatomic, strong) NSString *literature;
@property (nonatomic, strong) NSString *medium;
@property (nonatomic, strong) NSString *provenance;
@property (nonatomic, strong) NSString *series;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSDecimalNumber *width;
@property (nonatomic, strong) Artist *artist;

@property (nonatomic, strong) NSSet *collections;
- (NSMutableSet *)collectionsSet;

@property (nonatomic, strong) NSSet *editionSets;
- (NSMutableSet *)editionSetsSet;

@property (nonatomic, strong) NSSet *images;
- (NSMutableSet *)imagesSet;

@property (nonatomic, strong) NSSet *installShotsFeaturingArtwork;
- (NSMutableSet *)installShotsFeaturingArtworkSet;

@property (nonatomic, strong) NSSet *locations;
- (NSMutableSet *)locationsSet;
@property (nonatomic, strong) Image *mainImage;
@property (nonatomic, strong) Note *notes;
@property (nonatomic, strong) Partner *partner;

@property (nonatomic, strong) NSSet *shows;
- (NSMutableSet *)showsSet;


@end


@interface _Artwork (CollectionsCoreDataGeneratedAccessors)
- (void)addCollections:(NSSet *)value_;
- (void)removeCollections:(NSSet *)value_;
- (void)addCollectionsObject:(Album *)value_;
- (void)removeCollectionsObject:(Album *)value_;
@end


@interface _Artwork (EditionSetsCoreDataGeneratedAccessors)
- (void)addEditionSets:(NSSet *)value_;
- (void)removeEditionSets:(NSSet *)value_;
- (void)addEditionSetsObject:(EditionSet *)value_;
- (void)removeEditionSetsObject:(EditionSet *)value_;
@end


@interface _Artwork (ImagesCoreDataGeneratedAccessors)
- (void)addImages:(NSSet *)value_;
- (void)removeImages:(NSSet *)value_;
- (void)addImagesObject:(Image *)value_;
- (void)removeImagesObject:(Image *)value_;
@end


@interface _Artwork (InstallShotsFeaturingArtworkCoreDataGeneratedAccessors)
- (void)addInstallShotsFeaturingArtwork:(NSSet *)value_;
- (void)removeInstallShotsFeaturingArtwork:(NSSet *)value_;
- (void)addInstallShotsFeaturingArtworkObject:(Image *)value_;
- (void)removeInstallShotsFeaturingArtworkObject:(Image *)value_;
@end


@interface _Artwork (LocationsCoreDataGeneratedAccessors)
- (void)addLocations:(NSSet *)value_;
- (void)removeLocations:(NSSet *)value_;
- (void)addLocationsObject:(Location *)value_;
- (void)removeLocationsObject:(Location *)value_;
@end


@interface _Artwork (ShowsCoreDataGeneratedAccessors)
- (void)addShows:(NSSet *)value_;
- (void)removeShows:(NSSet *)value_;
- (void)addShowsObject:(Show *)value_;
- (void)removeShowsObject:(Show *)value_;
@end


@interface _Artwork (CoreDataGeneratedPrimitiveAccessors)

- (Artist *)primitiveArtist;
- (void)setPrimitiveArtist:(Artist *)value;

- (NSMutableSet *)primitiveCollections;
- (void)setPrimitiveCollections:(NSMutableSet *)value;

- (NSMutableSet *)primitiveEditionSets;
- (void)setPrimitiveEditionSets:(NSMutableSet *)value;

- (NSMutableSet *)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet *)value;

- (NSMutableSet *)primitiveInstallShotsFeaturingArtwork;
- (void)setPrimitiveInstallShotsFeaturingArtwork:(NSMutableSet *)value;

- (NSMutableSet *)primitiveLocations;
- (void)setPrimitiveLocations:(NSMutableSet *)value;

- (Image *)primitiveMainImage;
- (void)setPrimitiveMainImage:(Image *)value;

- (Note *)primitiveNotes;
- (void)setPrimitiveNotes:(Note *)value;

- (Partner *)primitivePartner;
- (void)setPrimitivePartner:(Partner *)value;

- (NSMutableSet *)primitiveShows;
- (void)setPrimitiveShows:(NSMutableSet *)value;

@end

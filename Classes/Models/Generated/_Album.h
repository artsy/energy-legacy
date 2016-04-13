// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Album.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"
extern const struct AlbumAttributes {
    __unsafe_unretained NSString *createdAt;
    __unsafe_unretained NSString *editable;
    __unsafe_unretained NSString *hasBeenEdited;
    __unsafe_unretained NSString *isPrivate;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *sortKey;
    __unsafe_unretained NSString *summary;
    __unsafe_unretained NSString *type;
    __unsafe_unretained NSString *updatedAt;
} AlbumAttributes;

extern const struct AlbumRelationships {
    __unsafe_unretained NSString *artists;
    __unsafe_unretained NSString *artworks;
    __unsafe_unretained NSString *cover;
    __unsafe_unretained NSString *documents;
    __unsafe_unretained NSString *uploadRecord;
} AlbumRelationships;

@class Artist;
@class Artwork;
@class Image;
@class Document;
@class AlbumEdit;


@interface AlbumID : NSManagedObjectID {
}
@end


@interface _Album : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (AlbumID *)objectID;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSNumber *editable;
@property (nonatomic, strong) NSNumber *hasBeenEdited;
@property (nonatomic, strong) NSNumber *isPrivate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSNumber *sortKey;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) NSSet *artists;
- (NSMutableSet *)artistsSet;

@property (nonatomic, strong) NSSet *artworks;
- (NSMutableSet *)artworksSet;
@property (nonatomic, strong) Image *cover;

@property (nonatomic, strong) NSSet *documents;
- (NSMutableSet *)documentsSet;
@property (nonatomic, strong) AlbumEdit *uploadRecord;

@end


@interface _Album (ArtistsCoreDataGeneratedAccessors)
- (void)addArtists:(NSSet *)value_;
- (void)removeArtists:(NSSet *)value_;
- (void)addArtistsObject:(Artist *)value_;
- (void)removeArtistsObject:(Artist *)value_;
@end


@interface _Album (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet *)value_;
- (void)removeArtworks:(NSSet *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;
@end


@interface _Album (DocumentsCoreDataGeneratedAccessors)
- (void)addDocuments:(NSSet *)value_;
- (void)removeDocuments:(NSSet *)value_;
- (void)addDocumentsObject:(Document *)value_;
- (void)removeDocumentsObject:(Document *)value_;
@end


@interface _Album (CoreDataGeneratedPrimitiveAccessors)

- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;

- (NSNumber *)primitiveEditable;
- (void)setPrimitiveEditable:(NSNumber *)value;

- (NSNumber *)primitiveHasBeenEdited;
- (void)setPrimitiveHasBeenEdited:(NSNumber *)value;

- (NSNumber *)primitiveIsPrivate;
- (void)setPrimitiveIsPrivate:(NSNumber *)value;

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (NSNumber *)primitiveSortKey;
- (void)setPrimitiveSortKey:(NSNumber *)value;

- (NSString *)primitiveSummary;
- (void)setPrimitiveSummary:(NSString *)value;

- (NSDate *)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate *)value;

- (NSMutableSet *)primitiveArtists;
- (void)setPrimitiveArtists:(NSMutableSet *)value;

- (NSMutableSet *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet *)value;

- (Image *)primitiveCover;
- (void)setPrimitiveCover:(Image *)value;

- (NSMutableSet *)primitiveDocuments;
- (void)setPrimitiveDocuments:(NSMutableSet *)value;

- (AlbumEdit *)primitiveUploadRecord;
- (void)setPrimitiveUploadRecord:(AlbumEdit *)value;

@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Album.h instead.

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
@class AlbumEdit;


@interface AlbumID : NSManagedObjectID
{
}
@end


@interface _Album : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) AlbumID *objectID;

@property (nonatomic, strong, nullable) NSDate *createdAt;

@property (nonatomic, strong, nullable) NSNumber *editable;

@property (atomic) BOOL editableValue;
- (BOOL)editableValue;
- (void)setEditableValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber *hasBeenEdited;

@property (atomic) BOOL hasBeenEditedValue;
- (BOOL)hasBeenEditedValue;
- (void)setHasBeenEditedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber *isPrivate;

@property (atomic) BOOL isPrivateValue;
- (BOOL)isPrivateValue;
- (void)setIsPrivateValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString *name;

@property (nonatomic, strong) NSString *slug;

@property (nonatomic, strong, nullable) NSNumber *sortKey;

@property (atomic) int16_t sortKeyValue;
- (int16_t)sortKeyValue;
- (void)setSortKeyValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString *summary;

@property (nonatomic, strong, nullable) NSString *type;

@property (nonatomic, strong, nullable) NSDate *updatedAt;

@property (nonatomic, strong, nullable) NSSet<Artist *> *artists;
- (nullable NSMutableSet<Artist *> *)artistsSet;

@property (nonatomic, strong, nullable) NSSet<Artwork *> *artworks;
- (nullable NSMutableSet<Artwork *> *)artworksSet;

@property (nonatomic, strong, nullable) Image *cover;

@property (nonatomic, strong, nullable) NSSet<Document *> *documents;
- (nullable NSMutableSet<Document *> *)documentsSet;

@property (nonatomic, strong, nullable) AlbumEdit *uploadRecord;

@end


@interface _Album (ArtistsCoreDataGeneratedAccessors)
- (void)addArtists:(NSSet<Artist *> *)value_;
- (void)removeArtists:(NSSet<Artist *> *)value_;
- (void)addArtistsObject:(Artist *)value_;
- (void)removeArtistsObject:(Artist *)value_;

@end


@interface _Album (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet<Artwork *> *)value_;
- (void)removeArtworks:(NSSet<Artwork *> *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;

@end


@interface _Album (DocumentsCoreDataGeneratedAccessors)
- (void)addDocuments:(NSSet<Document *> *)value_;
- (void)removeDocuments:(NSSet<Document *> *)value_;
- (void)addDocumentsObject:(Document *)value_;
- (void)removeDocumentsObject:(Document *)value_;

@end


@interface _Album (CoreDataGeneratedPrimitiveAccessors)

- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;

- (NSNumber *)primitiveEditable;
- (void)setPrimitiveEditable:(NSNumber *)value;

- (BOOL)primitiveEditableValue;
- (void)setPrimitiveEditableValue:(BOOL)value_;

- (NSNumber *)primitiveHasBeenEdited;
- (void)setPrimitiveHasBeenEdited:(NSNumber *)value;

- (BOOL)primitiveHasBeenEditedValue;
- (void)setPrimitiveHasBeenEditedValue:(BOOL)value_;

- (NSNumber *)primitiveIsPrivate;
- (void)setPrimitiveIsPrivate:(NSNumber *)value;

- (BOOL)primitiveIsPrivateValue;
- (void)setPrimitiveIsPrivateValue:(BOOL)value_;

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (NSNumber *)primitiveSortKey;
- (void)setPrimitiveSortKey:(NSNumber *)value;

- (int16_t)primitiveSortKeyValue;
- (void)setPrimitiveSortKeyValue:(int16_t)value_;

- (NSString *)primitiveSummary;
- (void)setPrimitiveSummary:(NSString *)value;

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

- (AlbumEdit *)primitiveUploadRecord;
- (void)setPrimitiveUploadRecord:(AlbumEdit *)value;

@end


@interface AlbumAttributes : NSObject
+ (NSString *)createdAt;
+ (NSString *)editable;
+ (NSString *)hasBeenEdited;
+ (NSString *)isPrivate;
+ (NSString *)name;
+ (NSString *)slug;
+ (NSString *)sortKey;
+ (NSString *)summary;
+ (NSString *)type;
+ (NSString *)updatedAt;
@end


@interface AlbumRelationships : NSObject
+ (NSString *)artists;
+ (NSString *)artworks;
+ (NSString *)cover;
+ (NSString *)documents;
+ (NSString *)uploadRecord;
@end

NS_ASSUME_NONNULL_END

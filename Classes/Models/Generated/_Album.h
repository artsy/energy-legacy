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
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
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

- (nullable NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(nullable NSDate *)value;

- (nullable NSNumber *)primitiveEditable;
- (void)setPrimitiveEditable:(nullable NSNumber *)value;

- (BOOL)primitiveEditableValue;
- (void)setPrimitiveEditableValue:(BOOL)value_;

- (nullable NSNumber *)primitiveHasBeenEdited;
- (void)setPrimitiveHasBeenEdited:(nullable NSNumber *)value;

- (BOOL)primitiveHasBeenEditedValue;
- (void)setPrimitiveHasBeenEditedValue:(BOOL)value_;

- (nullable NSNumber *)primitiveIsPrivate;
- (void)setPrimitiveIsPrivate:(nullable NSNumber *)value;

- (BOOL)primitiveIsPrivateValue;
- (void)setPrimitiveIsPrivateValue:(BOOL)value_;

- (nullable NSString *)primitiveName;
- (void)setPrimitiveName:(nullable NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (nullable NSNumber *)primitiveSortKey;
- (void)setPrimitiveSortKey:(nullable NSNumber *)value;

- (int16_t)primitiveSortKeyValue;
- (void)setPrimitiveSortKeyValue:(int16_t)value_;

- (nullable NSString *)primitiveSummary;
- (void)setPrimitiveSummary:(nullable NSString *)value;

- (nullable NSDate *)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(nullable NSDate *)value;

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

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Document.h instead.

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
@class Artist;
@class Show;


@interface DocumentID : NSManagedObjectID
{
}
@end


@interface _Document : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) DocumentID *objectID;

@property (nonatomic, strong, nullable) NSString *filename;

@property (nonatomic, strong, nullable) NSNumber *hasFile;

@property (atomic) BOOL hasFileValue;
- (BOOL)hasFileValue;
- (void)setHasFileValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString *humanReadableSize;

@property (nonatomic, strong, nullable) NSNumber *size;

@property (atomic) int32_t sizeValue;
- (int32_t)sizeValue;
- (void)setSizeValue:(int32_t)value_;

@property (nonatomic, strong) NSString *slug;

@property (nonatomic, strong, nullable) NSString *title;

@property (nonatomic, strong, nullable) NSString *url;

@property (nonatomic, strong, nullable) NSNumber *version;

@property (atomic) int16_t versionValue;
- (int16_t)versionValue;
- (void)setVersionValue:(int16_t)value_;

@property (nonatomic, strong, nullable) Album *album;

@property (nonatomic, strong, nullable) Artist *artist;

@property (nonatomic, strong, nullable) Show *show;

@end


@interface _Document (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString *)primitiveFilename;
- (void)setPrimitiveFilename:(nullable NSString *)value;

- (nullable NSNumber *)primitiveHasFile;
- (void)setPrimitiveHasFile:(nullable NSNumber *)value;

- (BOOL)primitiveHasFileValue;
- (void)setPrimitiveHasFileValue:(BOOL)value_;

- (nullable NSString *)primitiveHumanReadableSize;
- (void)setPrimitiveHumanReadableSize:(nullable NSString *)value;

- (nullable NSNumber *)primitiveSize;
- (void)setPrimitiveSize:(nullable NSNumber *)value;

- (int32_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int32_t)value_;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (nullable NSString *)primitiveTitle;
- (void)setPrimitiveTitle:(nullable NSString *)value;

- (nullable NSString *)primitiveUrl;
- (void)setPrimitiveUrl:(nullable NSString *)value;

- (nullable NSNumber *)primitiveVersion;
- (void)setPrimitiveVersion:(nullable NSNumber *)value;

- (int16_t)primitiveVersionValue;
- (void)setPrimitiveVersionValue:(int16_t)value_;

- (Album *)primitiveAlbum;
- (void)setPrimitiveAlbum:(Album *)value;

- (Artist *)primitiveArtist;
- (void)setPrimitiveArtist:(Artist *)value;

- (Show *)primitiveShow;
- (void)setPrimitiveShow:(Show *)value;

@end


@interface DocumentAttributes : NSObject
+ (NSString *)filename;
+ (NSString *)hasFile;
+ (NSString *)humanReadableSize;
+ (NSString *)size;
+ (NSString *)slug;
+ (NSString *)title;
+ (NSString *)url;
+ (NSString *)version;
@end


@interface DocumentRelationships : NSObject
+ (NSString *)album;
+ (NSString *)artist;
+ (NSString *)show;
@end

NS_ASSUME_NONNULL_END

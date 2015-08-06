// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Document.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct DocumentAttributes {
    __unsafe_unretained NSString *filename;
    __unsafe_unretained NSString *hasFile;
    __unsafe_unretained NSString *humanReadableSize;
    __unsafe_unretained NSString *size;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *title;
    __unsafe_unretained NSString *url;
    __unsafe_unretained NSString *version;
} DocumentAttributes;

extern const struct DocumentRelationships {
    __unsafe_unretained NSString *album;
    __unsafe_unretained NSString *artist;
    __unsafe_unretained NSString *show;
} DocumentRelationships;

@class Album;
@class Artist;
@class Show;


@interface DocumentID : NSManagedObjectID {
}
@end


@interface _Document : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (DocumentID *)objectID;

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSNumber *hasFile;
@property (nonatomic, strong) NSString *humanReadableSize;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) Artist *artist;
@property (nonatomic, strong) Show *show;

@end


@interface _Document (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveFilename;

- (void)setPrimitiveFilename:(NSString *)value;

- (NSNumber *)primitiveHasFile;

- (void)setPrimitiveHasFile:(NSNumber *)value;

- (NSString *)primitiveHumanReadableSize;

- (void)setPrimitiveHumanReadableSize:(NSString *)value;

- (NSNumber *)primitiveSize;

- (void)setPrimitiveSize:(NSNumber *)value;

- (NSString *)primitiveSlug;

- (void)setPrimitiveSlug:(NSString *)value;

- (NSString *)primitiveTitle;

- (void)setPrimitiveTitle:(NSString *)value;

- (NSString *)primitiveUrl;

- (void)setPrimitiveUrl:(NSString *)value;

- (NSNumber *)primitiveVersion;

- (void)setPrimitiveVersion:(NSNumber *)value;

- (Album *)primitiveAlbum;

- (void)setPrimitiveAlbum:(Album *)value;

- (Artist *)primitiveArtist;

- (void)setPrimitiveArtist:(Artist *)value;

- (Show *)primitiveShow;

- (void)setPrimitiveShow:(Show *)value;

@end

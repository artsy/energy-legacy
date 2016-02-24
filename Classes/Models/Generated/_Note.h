// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct NoteAttributes {
    __unsafe_unretained NSString *body;
    __unsafe_unretained NSString *createdAt;
    __unsafe_unretained NSString *updatedAt;
} NoteAttributes;

extern const struct NoteRelationships {
    __unsafe_unretained NSString *artwork;
} NoteRelationships;

extern const struct NoteUserInfo {
} NoteUserInfo;

@class Artwork;


@interface NoteID : ARManagedObjectID {
}
@end


@interface _Note : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (NoteID *)objectID;

@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) Artwork *artwork;


@end


@interface _Note (CoreDataGeneratedPrimitiveAccessors)

- (Artwork *)primitiveArtwork;
- (void)setPrimitiveArtwork:(Artwork *)value;

@end

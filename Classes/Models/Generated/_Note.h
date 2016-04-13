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

@class Artwork;


@interface NoteID : NSManagedObjectID {
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

- (NSString *)primitiveBody;
- (void)setPrimitiveBody:(NSString *)value;

- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;

- (NSDate *)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate *)value;

- (Artwork *)primitiveArtwork;
- (void)setPrimitiveArtwork:(Artwork *)value;

@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.h instead.

#if __has_feature(modules)
@import Foundation;
@import CoreData;
#else
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#endif

#import "ARManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class Artwork;


@interface NoteID : NSManagedObjectID
{
}
@end


@interface _Note : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) NoteID *objectID;

@property (nonatomic, strong) NSString *body;

@property (nonatomic, strong, nullable) NSDate *createdAt;

@property (nonatomic, strong, nullable) NSDate *updatedAt;

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


@interface NoteAttributes : NSObject
+ (NSString *)body;
+ (NSString *)createdAt;
+ (NSString *)updatedAt;
@end


@interface NoteRelationships : NSObject
+ (NSString *)artwork;
@end

NS_ASSUME_NONNULL_END

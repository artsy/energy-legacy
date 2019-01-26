// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Location.h instead.

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
@class Show;


@interface LocationID : NSManagedObjectID
{
}
@end


@interface _Location : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (nullable NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) LocationID *objectID;

@property (nonatomic, strong, nullable) NSString *address;

@property (nonatomic, strong, nullable) NSString *addressSecond;

@property (nonatomic, strong, nullable) NSString *city;

@property (nonatomic, strong, nullable) NSString *geoPoint;

@property (nonatomic, strong, nullable) NSString *name;

@property (nonatomic, strong, nullable) NSString *phone;

@property (nonatomic, strong, nullable) NSString *postalCode;

@property (nonatomic, strong) NSString *slug;

@property (nonatomic, strong, nullable) NSString *state;

@property (nonatomic, strong, nullable) NSSet<Artwork *> *artworks;
- (nullable NSMutableSet<Artwork *> *)artworksSet;

@property (nonatomic, strong, nullable) NSSet<Show *> *shows;
- (nullable NSMutableSet<Show *> *)showsSet;

@end


@interface _Location (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet<Artwork *> *)value_;
- (void)removeArtworks:(NSSet<Artwork *> *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;

@end


@interface _Location (ShowsCoreDataGeneratedAccessors)
- (void)addShows:(NSSet<Show *> *)value_;
- (void)removeShows:(NSSet<Show *> *)value_;
- (void)addShowsObject:(Show *)value_;
- (void)removeShowsObject:(Show *)value_;

@end


@interface _Location (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString *)primitiveAddress;
- (void)setPrimitiveAddress:(nullable NSString *)value;

- (nullable NSString *)primitiveAddressSecond;
- (void)setPrimitiveAddressSecond:(nullable NSString *)value;

- (nullable NSString *)primitiveCity;
- (void)setPrimitiveCity:(nullable NSString *)value;

- (nullable NSString *)primitiveGeoPoint;
- (void)setPrimitiveGeoPoint:(nullable NSString *)value;

- (nullable NSString *)primitiveName;
- (void)setPrimitiveName:(nullable NSString *)value;

- (nullable NSString *)primitivePhone;
- (void)setPrimitivePhone:(nullable NSString *)value;

- (nullable NSString *)primitivePostalCode;
- (void)setPrimitivePostalCode:(nullable NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (nullable NSString *)primitiveState;
- (void)setPrimitiveState:(nullable NSString *)value;

- (NSMutableSet<Artwork *> *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet<Artwork *> *)value;

- (NSMutableSet<Show *> *)primitiveShows;
- (void)setPrimitiveShows:(NSMutableSet<Show *> *)value;

@end


@interface LocationAttributes : NSObject
+ (NSString *)address;
+ (NSString *)addressSecond;
+ (NSString *)city;
+ (NSString *)geoPoint;
+ (NSString *)name;
+ (NSString *)phone;
+ (NSString *)postalCode;
+ (NSString *)slug;
+ (NSString *)state;
@end


@interface LocationRelationships : NSObject
+ (NSString *)artworks;
+ (NSString *)shows;
@end

NS_ASSUME_NONNULL_END

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Location.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"
extern const struct LocationAttributes {
    __unsafe_unretained NSString *address;
    __unsafe_unretained NSString *addressSecond;
    __unsafe_unretained NSString *city;
    __unsafe_unretained NSString *geoPoint;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *phone;
    __unsafe_unretained NSString *postalCode;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *state;
} LocationAttributes;

extern const struct LocationRelationships {
    __unsafe_unretained NSString *artworks;
    __unsafe_unretained NSString *shows;
} LocationRelationships;

@class Artwork;
@class Show;


@interface LocationID : NSManagedObjectID {
}
@end


@interface _Location : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
- (LocationID *)objectID;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *addressSecond;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *geoPoint;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *state;

@property (nonatomic, strong) NSSet *artworks;
- (NSMutableSet *)artworksSet;

@property (nonatomic, strong) NSSet *shows;
- (NSMutableSet *)showsSet;

@end


@interface _Location (ArtworksCoreDataGeneratedAccessors)
- (void)addArtworks:(NSSet *)value_;
- (void)removeArtworks:(NSSet *)value_;
- (void)addArtworksObject:(Artwork *)value_;
- (void)removeArtworksObject:(Artwork *)value_;
@end


@interface _Location (ShowsCoreDataGeneratedAccessors)
- (void)addShows:(NSSet *)value_;
- (void)removeShows:(NSSet *)value_;
- (void)addShowsObject:(Show *)value_;
- (void)removeShowsObject:(Show *)value_;
@end


@interface _Location (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveAddress;
- (void)setPrimitiveAddress:(NSString *)value;

- (NSString *)primitiveAddressSecond;
- (void)setPrimitiveAddressSecond:(NSString *)value;

- (NSString *)primitiveCity;
- (void)setPrimitiveCity:(NSString *)value;

- (NSString *)primitiveGeoPoint;
- (void)setPrimitiveGeoPoint:(NSString *)value;

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

- (NSString *)primitivePhone;
- (void)setPrimitivePhone:(NSString *)value;

- (NSString *)primitivePostalCode;
- (void)setPrimitivePostalCode:(NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (NSString *)primitiveState;
- (void)setPrimitiveState:(NSString *)value;

- (NSMutableSet *)primitiveArtworks;
- (void)setPrimitiveArtworks:(NSMutableSet *)value;

- (NSMutableSet *)primitiveShows;
- (void)setPrimitiveShows:(NSMutableSet *)value;

@end

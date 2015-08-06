// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EditionSet.h instead.

#import <CoreData/CoreData.h>
#import "ARManagedObject.h"

extern const struct EditionSetAttributes {
    __unsafe_unretained NSString *artistProofs;
    __unsafe_unretained NSString *availability;
    __unsafe_unretained NSString *availableEditions;
    __unsafe_unretained NSString *backendPrice;
    __unsafe_unretained NSString *depth;
    __unsafe_unretained NSString *diameter;
    __unsafe_unretained NSString *dimensionsCM;
    __unsafe_unretained NSString *dimensionsInches;
    __unsafe_unretained NSString *displayPrice;
    __unsafe_unretained NSString *duration;
    __unsafe_unretained NSString *editionSize;
    __unsafe_unretained NSString *editions;
    __unsafe_unretained NSString *height;
    __unsafe_unretained NSString *isAvailableForSale;
    __unsafe_unretained NSString *isPriceHidden;
    __unsafe_unretained NSString *prototypes;
    __unsafe_unretained NSString *slug;
    __unsafe_unretained NSString *width;
} EditionSetAttributes;

extern const struct EditionSetRelationships {
    __unsafe_unretained NSString *artwork;
} EditionSetRelationships;

@class Artwork;


@interface EditionSetID : NSManagedObjectID {
}
@end


@interface _EditionSet : ARManagedObject {
}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;

- (EditionSetID *)objectID;

@property (nonatomic, strong) NSString *artistProofs;
@property (nonatomic, strong) NSString *availability;
@property (nonatomic, strong) NSString *availableEditions;
@property (nonatomic, strong) NSString *backendPrice;
@property (nonatomic, strong) NSDecimalNumber *depth;
@property (nonatomic, strong) NSDecimalNumber *diameter;
@property (nonatomic, strong) NSString *dimensionsCM;
@property (nonatomic, strong) NSString *dimensionsInches;
@property (nonatomic, strong) NSString *displayPrice;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *editionSize;
@property (nonatomic, strong) NSString *editions;
@property (nonatomic, strong) NSDecimalNumber *height;
@property (nonatomic, strong) NSNumber *isAvailableForSale;
@property (nonatomic, strong) NSNumber *isPriceHidden;
@property (nonatomic, strong) NSString *prototypes;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSDecimalNumber *width;
@property (nonatomic, strong) Artwork *artwork;

@end


@interface _EditionSet (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveArtistProofs;
- (void)setPrimitiveArtistProofs:(NSString *)value;

- (NSString *)primitiveAvailability;
- (void)setPrimitiveAvailability:(NSString *)value;

- (NSString *)primitiveAvailableEditions;
- (void)setPrimitiveAvailableEditions:(NSString *)value;

- (NSString *)primitiveBackendPrice;
- (void)setPrimitiveBackendPrice:(NSString *)value;

- (NSDecimalNumber *)primitiveDepth;
- (void)setPrimitiveDepth:(NSDecimalNumber *)value;

- (NSDecimalNumber *)primitiveDiameter;
- (void)setPrimitiveDiameter:(NSDecimalNumber *)value;

- (NSString *)primitiveDimensionsCM;
- (void)setPrimitiveDimensionsCM:(NSString *)value;

- (NSString *)primitiveDimensionsInches;
- (void)setPrimitiveDimensionsInches:(NSString *)value;

- (NSString *)primitiveDisplayPrice;
- (void)setPrimitiveDisplayPrice:(NSString *)value;

- (NSString *)primitiveDuration;
- (void)setPrimitiveDuration:(NSString *)value;

- (NSString *)primitiveEditionSize;
- (void)setPrimitiveEditionSize:(NSString *)value;

- (NSString *)primitiveEditions;
- (void)setPrimitiveEditions:(NSString *)value;

- (NSDecimalNumber *)primitiveHeight;
- (void)setPrimitiveHeight:(NSDecimalNumber *)value;

- (NSNumber *)primitiveIsAvailableForSale;
- (void)setPrimitiveIsAvailableForSale:(NSNumber *)value;

- (NSNumber *)primitiveIsPriceHidden;
- (void)setPrimitiveIsPriceHidden:(NSNumber *)value;

- (NSString *)primitivePrototypes;
- (void)setPrimitivePrototypes:(NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (NSDecimalNumber *)primitiveWidth;
- (void)setPrimitiveWidth:(NSDecimalNumber *)value;

- (Artwork *)primitiveArtwork;
- (void)setPrimitiveArtwork:(Artwork *)value;

@end

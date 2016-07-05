// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EditionSet.h instead.

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


@interface EditionSetID : NSManagedObjectID
{
}
@end


@interface _EditionSet : ARManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_;
@property (nonatomic, readonly, strong) EditionSetID *objectID;

@property (nonatomic, strong, nullable) NSString *artistProofs;

@property (nonatomic, strong, nullable) NSString *availability;

@property (nonatomic, strong, nullable) NSString *availableEditions;

@property (nonatomic, strong, nullable) NSString *backendPrice;

@property (nonatomic, strong, nullable) NSDecimalNumber *depth;

@property (nonatomic, strong, nullable) NSDecimalNumber *diameter;

@property (nonatomic, strong, nullable) NSString *dimensionsCM;

@property (nonatomic, strong, nullable) NSString *dimensionsInches;

@property (nonatomic, strong, nullable) NSString *displayPrice;

@property (nonatomic, strong, nullable) NSString *duration;

@property (nonatomic, strong, nullable) NSString *editionSize;

@property (nonatomic, strong, nullable) NSString *editions;

@property (nonatomic, strong, nullable) NSDecimalNumber *height;

@property (nonatomic, strong, nullable) NSNumber *isAvailableForSale;

@property (atomic) BOOL isAvailableForSaleValue;
- (BOOL)isAvailableForSaleValue;
- (void)setIsAvailableForSaleValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber *isPriceHidden;

@property (atomic) BOOL isPriceHiddenValue;
- (BOOL)isPriceHiddenValue;
- (void)setIsPriceHiddenValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString *prototypes;

@property (nonatomic, strong, nullable) NSString *slug;

@property (nonatomic, strong, nullable) NSDecimalNumber *width;

@property (nonatomic, strong, nullable) Artwork *artwork;

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

- (BOOL)primitiveIsAvailableForSaleValue;
- (void)setPrimitiveIsAvailableForSaleValue:(BOOL)value_;

- (NSNumber *)primitiveIsPriceHidden;
- (void)setPrimitiveIsPriceHidden:(NSNumber *)value;

- (BOOL)primitiveIsPriceHiddenValue;
- (void)setPrimitiveIsPriceHiddenValue:(BOOL)value_;

- (NSString *)primitivePrototypes;
- (void)setPrimitivePrototypes:(NSString *)value;

- (NSString *)primitiveSlug;
- (void)setPrimitiveSlug:(NSString *)value;

- (NSDecimalNumber *)primitiveWidth;
- (void)setPrimitiveWidth:(NSDecimalNumber *)value;

- (Artwork *)primitiveArtwork;
- (void)setPrimitiveArtwork:(Artwork *)value;

@end


@interface EditionSetAttributes : NSObject
+ (NSString *)artistProofs;
+ (NSString *)availability;
+ (NSString *)availableEditions;
+ (NSString *)backendPrice;
+ (NSString *)depth;
+ (NSString *)diameter;
+ (NSString *)dimensionsCM;
+ (NSString *)dimensionsInches;
+ (NSString *)displayPrice;
+ (NSString *)duration;
+ (NSString *)editionSize;
+ (NSString *)editions;
+ (NSString *)height;
+ (NSString *)isAvailableForSale;
+ (NSString *)isPriceHidden;
+ (NSString *)prototypes;
+ (NSString *)slug;
+ (NSString *)width;
@end


@interface EditionSetRelationships : NSObject
+ (NSString *)artwork;
@end

NS_ASSUME_NONNULL_END

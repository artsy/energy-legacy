#import "_Partner.h"
#import "ARManagedObject.h"

typedef NS_ENUM(NSInteger, ARPartnerType) {
    ARPartnerTypeGallery,
    ARPartnerTypeCollector
};


@interface Partner : _Partner

/// Totes Deprecated.
+ (Partner *)currentPartner;

/// Use this one!
+ (Partner *)currentPartnerInContext:(NSManagedObjectContext *)context;

/// Thread-safe current partner ID
+ (NSString *)currentPartnerID;

/// Has the partner uploaded any works?
- (BOOL)hasUploadedWorks;

/// Does the partner have any published works?
- (BOOL)hasPublishedWorks;

/// Does the partner have any works for sale?
- (BOOL)hasForSaleWorks;

/// Does the partner have any works with prices?
- (BOOL)hasWorksWithPrice;

/// Does the partner have any confidential notes associated with their artworks?
- (BOOL)hasConfidentialNotes;

/// What kind of partner is it
- (ARPartnerType)type;

// Returns last CMS login date
- (NSDate *)lastCMSLoginDate;

@end

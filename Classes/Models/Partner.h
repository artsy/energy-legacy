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

/// What kind of partner is it
- (ARPartnerType)type;

// Returns last CMS login date
- (NSDate *)lastCMSLoginDate;

@end

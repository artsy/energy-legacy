typedef NS_ENUM(NSInteger, AREmailSettingsPriceType) {
    AREmailSettingsPriceTypeNoPrice,
    AREmailSettingsPriceTypeFront,
    AREmailSettingsPriceTypeBackend
};

/// A dumb settings object, only holds state to act
/// as information for the AREmailSettingViewController
///
@interface AREmailSettings : NSObject

@property (nonatomic, copy, readwrite) NSArray *artworks;
@property (nonatomic, copy, readwrite) NSArray *documents;
@property (nonatomic, copy, readwrite) NSArray *additionalImages;
@property (nonatomic, copy, readwrite) NSArray *installationShots;

@property (nonatomic, assign, readwrite) BOOL showSupplementaryInformation;
@property (nonatomic, assign, readwrite) BOOL showInventoryID;
@property (nonatomic, assign, readwrite) AREmailSettingsPriceType priceType;

// Can't do logic in email's markdown, so we have computer properties
// off the priceType

@property (nonatomic, assign, readonly) BOOL showBackendPrice;
@property (nonatomic, assign, readonly) BOOL showPrice;

@end

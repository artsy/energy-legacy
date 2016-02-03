typedef NS_ENUM(NSInteger, AREmailSubjectType) {
    AREmailSubjectTypeOneArtwork,
    AREmailSubjectTypeMultipleArtworksMultipleArtists,
    AREmailSubjectTypeMultipleArtworksSameArtist,
};


@interface AREmailSettingsViewModel : NSObject

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults;

- (NSString *)savedStringForEmailDefault:(NSString *)key;

- (NSString *)savedStringForSubjectType:(AREmailSubjectType)type;

- (void)setEmailDefault:(NSString *)string WithKey:(NSString *)key;

- (void)saveSubjectLine:(NSString *)line ForType:(AREmailSubjectType)type;

- (NSString *)titleForEmailSubjectType:(AREmailSubjectType)type;

- (NSString *)explanatoryTextForSubjectType:(AREmailSubjectType)type;

- (NSString *)signatureExplanatoryText;

@end

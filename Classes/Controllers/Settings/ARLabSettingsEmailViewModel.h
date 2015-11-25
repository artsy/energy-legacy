@interface ARLabSettingsEmailViewModel : NSObject

- (NSString *)savedStringForEmailDefault:(NSString *)key;

- (void)setEmailDefault:(NSString *)string WithKey:(NSString *)key;

- (NSString *)signatureExplanatoryText;

@end

// All the options as consts
extern NSString *const AROptionsUseWhiteFolio;

extern const NSString *AROptionsKey;
extern const NSString *AROptionsName;


@interface AROptions : NSObject

/// Returns all the current options
+ (NSArray *)labsOptions;

/// Get and set individual options
+ (BOOL)boolForOption:(NSString *)option;

+ (void)setBool:(BOOL)value forOption:(NSString *)option;

@end

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIDeviceType) {
    UIDeviceIpad1,
    UIDeviceIpad2,
    UIDeviceIpad3Plus,
    UIDeviceIphone3GS,
    UIDeviceIphone4,
    UIDeviceIphone5Plus,
    UIDeviceOther
};


@interface UIDevice (deviceInfo)

/// Useful if you just want to know if the screen height is > iPhone 4/4S (480)
+ (BOOL)hasSmallScreen;

/// Useful if you want to know if you have a 5s and below.
+ (BOOL)hasHorizontallyConstrainedScreen;

+ (NSString *)deviceString;

+ (NSInteger)deviceType;

+ (BOOL)isPad;

+ (BOOL)isPhone;

+ (BOOL)isIOS8Plus;

@end

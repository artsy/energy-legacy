

@implementation UIDevice (DeviceInfo)

+ (NSString *)deviceString
{
    if ([self isPad]) {
        return @"iPad";
    }
    return @"iPhone";
}

+ (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone;
}

+ (BOOL)isPadPro
{
    CGFloat longestEdge = MAX(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    return [self isPad] && longestEdge == 1366;
}


+ (BOOL)isPhone
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+ (NSInteger)deviceType
{
#if TARGET_IPHONE_SIMULATOR
    return UIDeviceOther;
#endif
    bool isRetina = [[UIScreen mainScreen] scale] > 1;
    if ([self isPad]) {
        if (isRetina) {
            return UIDeviceIpad3Plus;
        } else {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                return UIDeviceIpad2;
            }
            return UIDeviceIpad1;
        }
    } else {
        if (isRetina) {
            bool isFourInches = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 1136));
            if (isFourInches) {
                return UIDeviceIphone5Plus;
            } else {
                return UIDeviceIphone4;
            }

        } else {
            return UIDeviceIphone3GS;
        }
    }
}

+ (BOOL)hasSmallScreen
{
    return (CGRectGetHeight([[UIScreen mainScreen] bounds]) <= 480);
}

+ (BOOL)hasHorizontallyConstrainedScreen
{
    return (CGRectGetWidth([[UIScreen mainScreen] bounds]) <= 320);
}

+ (BOOL)isIOS8Plus
{
    if (&UIApplicationOpenSettingsURLString != NULL) {
        return YES;
    }
    return NO;
}

@end

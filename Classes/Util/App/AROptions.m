#import "AROptions.h"

NSString *const AROptionsUseWhiteFolio = @"White Folio";
NSString *const AROptionsUseLabSettings = @"AROptionsUseLabSettings";

const NSString *AROptionsKey = @"ARDefaultKey";
const NSString *AROptionsName = @"ARDefaultName";


@implementation AROptions

+ (NSArray *)labsOptions
{
    return @[
        @{ AROptionsKey : @"show_artwork_edit",
           AROptionsName : @"Show Artwork Edit Button" },

        @{ AROptionsKey : AROptionsUseLabSettings,
           AROptionsName : @"Use Lab Settings Panel" },
    ];
}

+ (BOOL)boolForOption:(NSString *)option
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:option];
}

+ (void)setBool:(BOOL)value forOption:(NSString *)option
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:option];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

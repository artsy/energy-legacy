#import "AROptions.h"

NSString *const AROptionsUseWhiteFolio = @"White Folio";

const NSString *AROptionsKey = @"ARDefaultKey";
const NSString *AROptionsName = @"ARDefaultName";


@implementation AROptions

+ (NSArray *)labsOptions
{
    return @[
        @{ AROptionsKey : @"album_sync",
           AROptionsName : @"Sync Local Albums" },
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

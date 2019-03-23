#import "AROptions.h"

NSString *const AROptionsUseWhiteFolio = @"White Folio";
NSString *const ARSyncAlbumsOption = @"lab_album_sync";

NSString *const AROptionsKey = @"ARDefaultKey";
NSString *const AROptionsName = @"ARDefaultName";

@implementation AROptions

+ (NSArray *)labsOptions
{
    return @[
        @{ AROptionsKey : ARSyncAlbumsOption,
           AROptionsName : @"Sync Local Albums with CMS" },
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

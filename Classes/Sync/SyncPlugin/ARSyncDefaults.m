#import "ARSyncDefaults.h"


@implementation ARSyncDefaults

- (void)syncDidFinish:(ARSync *)sync
{
    NSUserDefaults *defaults = sync.config.defaults;
    [defaults setBool:YES forKey:ARFinishedFirstSync];
    [defaults setObject:NSDate.date forKey:ARLastSyncDate];
    [defaults setBool:NO forKey:ARRecommendSync];

    NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    [defaults setObject:appVersion forKey:ARAppSyncVersion];

    [defaults synchronize];
}

@end

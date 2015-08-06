#import "UIDevice+UserAgent.h"
#import <sys/sysctl.h>

static NSString *userAgentString;


@implementation UIDevice (UserAgent)
+ (NSString *)userAgent
{
    if (!userAgentString) {
        //https://gist.github.com/1323251
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = @(machine);
        free(machine);
        userAgentString = [NSString stringWithFormat:@"Artsy Folio %@/%@/%@",
                                                     [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"],
                                                     platform,
                                                     [[UIDevice currentDevice] systemVersion]];
    }
    return userAgentString;
}
@end

#import "ARAppTestDelegate.h"
#import <Expecta+Snapshots/ExpectaObject+FBSnapshotTest.h>


@implementation ARAppTestDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen.mainScreen bounds]];
    [self.window makeKeyWindow];

    return YES;
}

@end

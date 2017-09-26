#import "ARAppTestDelegate.h"
#import <Expecta+Snapshots/ExpectaObject+FBSnapshotTest.h>

@implementation ARAppTestDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Expecta setUsesDrawViewHierarchyInRect:YES];
    return YES;
}

@end

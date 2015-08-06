#import "ARAppDelegate.h"
#import "ARAppTestDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        BOOL isRunningTests = NSClassFromString(@"XCTestCase") != nil;
        Class appDelegateClass = isRunningTests ? [ARAppTestDelegate class] : [ARAppDelegate class];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}

#import <Foundation/Foundation.h>


@interface ARLogoutManager : NSObject
+ (instancetype)sharedLogoutManager;

- (void)run;
@end

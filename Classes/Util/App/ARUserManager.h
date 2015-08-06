#import <Foundation/Foundation.h>


@interface ARUserManager : NSObject
+ (BOOL)userIsLoggedIn;

+ (void)expireAuthToken;

+ (BOOL)loginCredentialsExist;

+ (void)requestLoginWithStoredCredentials;

+ (void)requestLoginWithUsername:(NSString *)username andPassword:(NSString *)password;
@end

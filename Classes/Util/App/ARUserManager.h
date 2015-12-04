#import <Foundation/Foundation.h>

/// Handles interacting with user state
/// and logging in.


@interface ARUserManager : NSObject

/// User is logged in and token is still valid
- (BOOL)userIsLoggedIn;

/// User has credentials in the defaults
/// but we don't know if they're logged in
- (BOOL)userCredentialsExist;

/// Uses the stored credentials to log in transparently
- (void)requestLoginWithStoredCredentials;

/// Logs in with the username / password
- (void)requestLoginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL success, NSError *error))completion;
@end

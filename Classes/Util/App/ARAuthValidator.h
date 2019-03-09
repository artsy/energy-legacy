#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Handles making sure auth tokens are
/// correctly set up to talk to gravity
@interface ARAuthValidator : NSObject

/// Called when the app opens, it launches
/// an API request for user metadata and checks if the
/// response is a 401 - if so, then it will
/// try use existing auth creds to get a new token
/// if not, then it will log out
+ (void)validateAuthCredentialsAreCorrect;
@end

NS_ASSUME_NONNULL_END

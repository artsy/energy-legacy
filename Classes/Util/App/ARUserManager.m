#import "ARUserManager.h"
#import "SFHFKeychainUtils.h"
#import "ARRouter.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import <Artsy+Authentication/Artsy+Authentication.h>
#import <Keys/FolioKeys.h>


@interface ARUserManager ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) ArtsyAuthentication *auth;
@end


@implementation ARUserManager

- (BOOL)userIsLoggedIn
{
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:AROAuthToken];
    NSDate *expiryDate = [[NSUserDefaults standardUserDefaults] objectForKey:AROAuthTokenExpiryDate];

    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    NSTimeInterval gmtTimeInterval = [NSDate timeIntervalSinceReferenceDate] - timeZoneOffset;
    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];

    BOOL tokenValid = expiryDate && [gmtDate earlierDate:expiryDate] != expiryDate;
    return authToken && tokenValid;
}

- (BOOL)userCredentialsExist
{
    return ([self.userDefaults valueForKey:ARUserEmailAddress] != nil);
}

- (void)expireAuthToken
{
    [self.userDefaults removeObjectForKey:AROAuthTokenExpiryDate];
}

- (void)requestLoginWithStoredCredentials
{
    NSString *username = [self.userDefaults valueForKey:ARUserEmailAddress];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:ARAppName error:nil];
    [self requestLoginWithUsername:username andPassword:password completion:nil];
}

- (void)requestLoginWithUsername:(NSString *)username andPassword:(NSString *)password completion:(void (^)(BOOL success, NSError *error))completion
{
    FolioKeys *keys = [[FolioKeys alloc] init];
    _auth = self.auth ?: [[ArtsyAuthentication alloc] initWithClientID:keys.artsyAPIClientKey clientSecret:keys.artsyAPIClientSecret];
    [self.auth logInWithEmail:username password:password completion:^(ArtsyToken *token, NSError *error) {

        if (token) {
            [self saveToken:token email:username];
            [ARRouter setAuthToken:token.token];
            [self saveEmail:username password:password];
        }

        if (completion) {
            completion(token != nil, error);
        }
    }];
}

- (void)saveToken:(ArtsyToken *)token email:(NSString *)email
{
    NSUserDefaults *defaults = self.userDefaults;
    [defaults setObject:token.token forKey:AROAuthToken];
    [defaults setObject:token.expirationDate forKey:AROAuthTokenExpiryDate];
    [defaults setObject:email forKey:ARUserEmailAddress];
    [defaults synchronize];
}

- (void)saveEmail:(NSString *)email password:(NSString *)password
{
    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:email andPassword:password forServiceName:ARAppName updateExisting:YES error:&error];
    if (error) {
        [self.userDefaults removeObjectForKey:ARUserEmailAddress];
        [self.userDefaults synchronize];
        NSLog(@"Error saving to keychain : %@", error.localizedDescription);
    }
}

- (NSUserDefaults *)userDefaults
{
    return _userDefaults ?: [NSUserDefaults standardUserDefaults];
}


@end

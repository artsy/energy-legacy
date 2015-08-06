#import "ARUserManager.h"
#import "SFHFKeychainUtils.h"
#import "ARRouter.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

static ARUserManager *sharedUserManager;


@implementation ARUserManager

+ (ARUserManager *)sharedUserManager
{
    if (sharedUserManager) {
        return sharedUserManager;
    }
    sharedUserManager = [[ARUserManager alloc] init];

    return sharedUserManager;
}

+ (BOOL)userIsLoggedIn
{
    return [[ARUserManager sharedUserManager] userIsLoggedIn];
}

+ (void)loginComplete:(NSDictionary *)theJSON withEmail:(NSString *)email andPassword:(NSString *)password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *expiryDateString = theJSON[AROAuthTokenExpiryDateKey];

    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    NSDate *expiryDate = [dateFormatter dateFromString:expiryDateString];
    NSString *accessToken = theJSON[AROAuthTokenKey];

    [defaults setObject:accessToken forKey:AROAuthToken];
    [ARRouter setAuthToken:accessToken];

    //TODO: Unit test me
    [defaults setObject:expiryDate forKey:AROAuthTokenExpiryDate];
    [defaults setObject:email forKey:ARUserEmailAddress];
    [defaults synchronize];

    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:email andPassword:password
                      forServiceName:ARAppName
                      updateExisting:YES
                               error:&error];
    if (error) {
        [defaults removeObjectForKey:ARUserEmailAddress];
        NSLog(@"Error saving to keychain : %@", error.localizedDescription);
    }

    NSDictionary *info = @{
        AROAuthTokenNotificationKey : accessToken,
        AROAuthTokenExpiryDateNotificationKey : expiryDate
    };

    [[NSNotificationCenter defaultCenter] postNotificationName:ARLoginCompleteNotification object:nil userInfo:info];
}

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

+ (BOOL)loginCredentialsExist
{
    return ([[NSUserDefaults standardUserDefaults] valueForKey:ARUserEmailAddress] != nil);
}

+ (void)expireAuthToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AROAuthTokenExpiryDate];
}

+ (void)requestLoginWithStoredCredentials
{
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:ARUserEmailAddress];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:ARAppName error:nil];
    [self requestLoginWithUsername:username andPassword:password];
}

+ (void)requestLoginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSURLRequest *request = [ARRouter newOAuthRequestWithUsername:username password:password];

    //you might think: 'It'd be nice to typedef these blocks!'
    //but here's a compelling argument against that
    //https://github.com/AFNetworking/AFNetworking/issues/102

    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
             [ARUserManager loginComplete:JSON withEmail:username andPassword:password];
        }

        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
             NSString *notification = JSON ? ARLoginFailedNotification : ARLoginFailedServerNotification;
             [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
        }];
    [op start];
}
@end

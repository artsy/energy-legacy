#import "AROAuthOperation.h"
#import "NSDate+GMT.h"
#import "ARNotifications.h"
#import "ARRouter.h"
#import "NSObject+SBJSON.h"
#import "ARFeedKeys.h"
#import "ARDefaults.h"


@implementation AROAuthOperation

- (id)init
{
    // Prevent using default initializer
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)main
{
    @autoreleasepool
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        // 2012-07-22T03:18:55-07:00
        // We split the date at the T right now
        // as iOS6 seems to not like our old
        // date formatter

        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
        [dateFormatter setLenient:YES];
        [super main];
    }
}

- (id)initWithStoredUsernameAndPassword
{
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:ARUserEmailAddress];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:ARAppName error:nil];
    return [self initWithUsername:username password:password];
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password
{
    NSURL *url = [ARRouter newOAuthURLWithUsername:username password:password];
    if (self = [super initWithURL:url]) {
        // setup
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *jsonString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSDictionary *objects = (NSDictionary *)
        [jsonString JSONValue];

    if ([objects isKindOfClass:[NSDictionary class]] && [(NSDictionary *)objects objectForKey:ARFeedErrorKey]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ARLoginFailedNotification object:self];
    } else {
        if ([objects isKindOfClass:[NSDictionary class]]) {
            NSString *accessToken = [objects objectForKey:AROAuthTokenKey];
            NSString *expiryDateString = [[[objects objectForKey:AROAuthTokenExpiryDateKey] componentsSeparatedByString:@"T"] objectAtIndex:0];
            NSDate *expiryDate = [dateFormatter dateFromString:expiryDateString];

            NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:accessToken, AROAuthTokenNotificationKey,
                                                                              expiryDate, AROAuthTokenExpiryDateNotificationKey,
                                                                              nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:ARLoginCompleteNotification object:nil userInfo:info];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:ARLoginFailedServerNotification object:self];
        }
    }
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), request.URL);
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [[NSNotificationCenter defaultCenter] postNotificationName:ARLoginFailedNotification object:self];
    [self finish];
}

@end

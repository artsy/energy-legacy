#import "ARAuthValidator.h"
#import "ARLoginNetworkModel.h"
#import "ARUserManager.h"
#import "ARAppDelegate.h"


@implementation ARAuthValidator

+ (void)validateAuthCredentialsAreCorrect
{
    ARLoginNetworkModel *model = [ARLoginNetworkModel new];
    [model getUserInformation:^(id userInfo) {
        // NOOP because it means this is fine
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (response.statusCode == 401) {
            [[ARUserManager new] requestLoginWithStoredCredentialsCompletion:^(BOOL success, NSError *error) {
                if (!success) {
                    [self logout];
                }
            }];
        }
    }];
}

+ (void)logout
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Session expired" message:@"Please log in to continue" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        ARAppDelegate *appDelegate = (id)[UIApplication sharedApplication].delegate;
        [appDelegate startLogout];
    }];

    [alert addAction:defaultAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end

#import "ARLoginViewController.h"
#import "ARSync.h"
#import "ARRouter.h"
#import "ARFeedTranslator.h"
#import "Reachability.h"
#import "ARUserManager.h"
#import "ARMyPartnersOperation.h"
#import "ARPartnerSelectViewController.h"
#import "UIDevice+SpaceStats.h"
#import "ARBaseViewController+TransparentModals.h"
#import "ARAdminPartnerSelectViewController.h"
#import "ARTextFieldWithPlaceholder.h"
#import "UIDevice+Testing.h"
#import "ARLoginNetworkModel.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>


@interface ARLoginViewController ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *passwordLabel;
@property (nonatomic, weak) IBOutlet UILabel *welcomeMessageLabel;
@property (nonatomic, weak) IBOutlet UIButton *clearEmailButton;
@property (nonatomic, weak) IBOutlet UIButton *clearPasswordButton;
@property (nonatomic, weak) IBOutlet UILabel *iphoneSubheadingLabel;
@property (nonatomic, weak) IBOutlet UILabel *appAdviceText;
@property (weak, nonatomic) IBOutlet UIView *appRecommendationView;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) UIApplication *sharedApplication;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ARLoginNetworkModel *networkModel;
@property (nonatomic, strong) ARUserManager *userManager;
@end


@implementation ARLoginViewController

- (instancetype)init
{
    if ([UIDevice isPhone]) {
        return [super initWithNibName:@"ARPhoneLoginViewController" bundle:nil];
    } else {
        return [super init];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    UIFont *garamond = [UIFont serifFontWithSize:ARFontSerif];
    UIFont *labelFont = [UIFont sansSerifFontWithSize:ARFontLoginLabel];

    self.emailTextField.font = garamond;
    self.passwordTextField.font = garamond;

    self.emailLabel.font = labelFont;
    self.passwordLabel.font = labelFont;

    self.errorMessageLabel.font = [UIFont serifFontWithSize:ARFontSerifSmall];

    self.welcomeMessageLabel.font = [UIFont sansSerifFontWithSize:ARFontSansLarge];
    self.welcomeMessageLabel.text = [self.welcomeMessageLabel.text uppercaseString];
    self.iphoneSubheadingLabel.font = [UIFont serifFontWithSize:ARFontSerifSmall];
    self.appAdviceText.font = [UIFont serifFontWithSize:ARFontSerifSmall];

    self.errorMessageLabel.text = @"";
    self.errorMessageLabel.lineHeight = 6;
    self.errorMessageLabel.backgroundColor = [UIColor blackColor];

    if (![self.userDefaults boolForKey:ARStartedFirstSync]) {
        self.errorMessageLabel.text = @"Once you log in, Artsy Folio will begin downloading your artworks. You should use a WiFi enabled connection.";
    }

    if (self.artsyMobileIsInstalled) {
        self.appAdviceText.text = @"Looking for Artsy Mobile? Tap here to open";
    } else {
        self.appAdviceText.text = @"Looking for Artsy Mobile? Tap here to install";
    }

    [self.clearEmailButton setImage:[UIImage imageNamed:@"Remove_Clean_Button_Active.png"]
                           forState:UIControlStateHighlighted];
    [self.clearPasswordButton setImage:[UIImage imageNamed:@"Remove_Clean_Button_Active.png"]
                              forState:UIControlStateHighlighted];

    [@[ self.emailTextField, self.passwordTextField ] each:^(UITextField *textField) {
        [textField addTarget:self action:@selector(checkForClearButton:) forControlEvents:UIControlEventEditingDidBegin];
        [textField addTarget:self action:@selector(checkForClearButton:) forControlEvents:UIControlEventEditingChanged];
        [textField addTarget:self action:@selector(checkForClearButton:) forControlEvents:UIControlEventEditingDidEnd];
    }];

    if (![UIDevice isPad]) {
        self.emailTextField.placeholder = @"Email";
        self.passwordTextField.placeholder = @"Password";
    }

#if (TARGET_IPHONE_SIMULATOR)
    [self setupDefaultUsernameAndPassword];
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([UIDevice isPad]) {
        [self.emailTextField becomeFirstResponder];
    }
}

- (BOOL)artsyMobileIsInstalled
{
    NSURL *url = [NSURL URLWithString:@"artsy:/"];
    return [self.sharedApplication canOpenURL:url];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Hide the "looking for artsy iOS" when in iPad landscape
    self.appRecommendationView.hidden = UIInterfaceOrientationIsLandscape(interfaceOrientation);

    return YES;
}

#pragma mark IB Actions

- (IBAction)login:(id)sender
{
    if (![self validatesWithMessage:YES]) return;

    [self loginWithUsername:self.emailTextField.text andPassword:self.passwordTextField.text];

    [self startLoading:YES];
    [self.view endEditing:YES];
}

- (void)startLoading:(BOOL)loading
{
    if (loading) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }

    self.loginButton.enabled = !loading;
    self.loginButton.alpha = loading ? 0.3 : 1;
}

- (IBAction)clearEmail:(id)sender
{
    self.emailTextField.text = @"";
    self.clearEmailButton.hidden = YES;
}

- (IBAction)clearPassword:(id)sender
{
    self.passwordTextField.text = @"";
    self.clearPasswordButton.hidden = YES;
}

- (void)checkForClearButton:(UITextField *)sender
{
    self.clearEmailButton.hidden = ([self.emailTextField.text length] == 0);
    self.clearPasswordButton.hidden = ([self.passwordTextField.text length] == 0);
}

- (IBAction)openOtherAppTapped:(id)sender
{
    NSString *address = self.artsyMobileIsInstalled ? @"artsy:/" : @"https://itunes.apple.com/us/app/artsy-art-world-in-your-pocket/id703796080?ls=1&mt=8";
    NSURL *url = [NSURL URLWithString:address];
    [self.sharedApplication openURL:url];
}

- (BOOL)validatesWithMessage:(BOOL)showMessage
{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (status == NotReachable) {
        if (showMessage) [self resetWithErrorMessage:@"Please connect to the internet before logging in."];
        return NO;
    }

    if (status == ReachableViaWWAN) {
        if (showMessage) [self resetWithErrorMessage:@"Please connect to a WIFI connection before logging in."];
        return NO;
    }

    if ([self.emailTextField.text length] < 1 && [self.passwordTextField.text length] < 1) {
        if (showMessage) [self resetWithErrorMessage:@"Please enter your email and password."];
        return NO;
    }

    if ([self.emailTextField.text length] < 1) {
        if (showMessage) [self resetWithErrorMessage:@"Please enter your email address."];
        return NO;
    }

    if ([self.passwordTextField.text length] < 1) {
        if (showMessage) [self resetWithErrorMessage:@"Please enter your password."];
        return NO;
    }

    return YES;
}

#pragma mark -
#pragma mark Login and login notification methods

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    if ([username isEqualToString:@"orta"]) {
        username = @"orta@artsymail.com";
    }

    _userManager = self.userManager ?: [[ARUserManager alloc] init];
    [self.userManager requestLoginWithUsername:username andPassword:password completion:^(BOOL success, NSError *error) {
        if (success) {
            [self loginCompleted];
        } else {
            [self handleNetworkError:error];
        }
    }];
}

- (void)handleNetworkError:(NSError *)error
{
    ar_dispatch_main_queue(^{
        [self startLoading:NO];
    });

    [self.networkModel pingArtsy:^(BOOL connected, NSTimeInterval timeToConnect) {
        if (connected) {
            // Artsy is up
            NSString *serverError = error.userInfo[@"error_description"];

            /// Let's have a less robotic error message for the most
            /// common case.
            if ([serverError isEqualToString:@"invalid email or password"] || error.code == 401) {
                serverError = @"Your email or password is incorrect.";
            }

            if (serverError) {
                ar_dispatch_main_queue(^{
                    [self resetWithErrorMessage:serverError];
                });
            }
            return;
        }

        // Artsy is offline?
        [self.networkModel pingApple:^(BOOL connected, NSTimeInterval timeToConnect) {
            ar_dispatch_main_queue(^{
                if (connected) {
                    /// If Apple is up, and we are down, then we are down for sure.
                    [self resetWithErrorMessage:@"Our servers are experiencing temporary technical difficulties. We have been notified of the problem and are working to fix it. Please contact partnersupport@artsy.net with any questions."];
                } else {
                    /// OK, they are definitely offline.
                    [self resetWithErrorMessage:@"Folio is having trouble connecting to Artsy, and the internet in general, you may be having WIFI or networking issues."];
                }
            });
        }];
    }];
}

- (void)loginCompleted
{
    // We need User info for analytics, and for testing if they're an admin
    [self.networkModel getUserInformation:^(id userInfo) {
        User *user = [User addOrUpdateWithDictionary:userInfo inContext:self.managedObjectContext saving:YES];

        if ([user isAdmin]) {
            [self presentAdminPartnerSelectionTool];
        } else {
            [self getCurrentUserPartnerInfo];
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //  Worrying, but we can live with it.
        ARSyncLog(@"Failed to get User info JSON");
        [self getCurrentUserPartnerInfo];
    }];
}

- (Partner *)parseJSONIntoPartner:(NSDictionary *)json
{
    Partner *partner = [Partner addOrUpdateWithDictionary:json inContext:self.managedObjectContext saving:YES];
    [[NSUserDefaults standardUserDefaults] setObject:partner.slug forKey:ARPartnerID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return partner;
}

- (void)getCurrentUserPartnerInfo
{
    [self.networkModel getCurrentUserPartnersWithSuccess:^(id JSON, ARLoginPartnerCount partnerCount) {
        switch (partnerCount) {
            case ARLoginPartnerCountNone: {
                [self resetWithErrorMessage:@"Your account is not associated with an Artsy Partner account. Please contact partnersupport@artsy.net with any questions."];
                [ARAnalytics event:ARNoPartnersEvent];
                [self.userDefaults removeObjectForKey:AROAuthToken];
                [self.userDefaults removeObjectForKey:AROAuthTokenExpiryDate];
                break;
            }
            case ARLoginPartnerCountOne: {
                [self.networkModel getFullMetadataForPartnerWithID:JSON[0][ARFeedIDKey] success:^(id partnerMetadata) {
                    [self parseJSONIntoPartner:partnerMetadata];
                    [self validateAndExitLoginScreen];
                } failure:nil];
                break;
            }
            case ARLoginPartnerCountMany: {
                [self presentPartnerSelectionToolWithJSON:JSON];
                break;
            }
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self resetWithErrorMessage:@"Our servers are experiencing temporary technical difficulties. We have been notified of the problem and are working to fix it. Please contact partnersupport@artsy.net with any questions."];
    }];
}

- (void)presentAdminPartnerSelectionTool
{
    ARAdminPartnerSelectViewController *partnerSelect = [[ARAdminPartnerSelectViewController alloc] init];

    partnerSelect.callback = ^(NSDictionary *partnerDictionary) {

        [self parseJSONIntoPartner:partnerDictionary];
        [self dismissViewControllerAnimated:YES completion:^{
            [self validateAndExitLoginScreen];
        }];
    };

    [self presentViewController:partnerSelect animated:NO completion:nil];
}

- (void)presentPartnerSelectionToolWithJSON:(NSArray *)JSON
{
    ARPartnerSelectViewController *partnerSelect = [[ARPartnerSelectViewController alloc] init];
    partnerSelect.partners = JSON;
    partnerSelect.callback = ^(NSDictionary *partnerDictionary) {

        [self.networkModel getFullMetadataForPartnerWithID:partnerDictionary[ARFeedIDKey] success:^(id fullPartnerMetadata) {
            [self parseJSONIntoPartner:fullPartnerMetadata];
            [self dismissViewControllerAnimated:YES completion:^{
                [self validateAndExitLoginScreen];
            }];
        } failure:nil];
    };

    [self presentViewController:partnerSelect animated:NO completion:nil];
}

- (void)validateAndExitLoginScreen
{
    if ([self checkForAllowingAccess] && [self checkForEnoughFreeSpace]) {
        // Remove any potential modals from the above
        if (self.transparentModalViewController) {
            [self dismissTransparentModalViewControllerAnimated:YES];
        }

        // This kills the login screen and moves on.
        if (_completionBlock) {
            _completionBlock();
        }
    }
}

/// Passes true when it's fine to move out of the login screen
- (BOOL)checkForEnoughFreeSpace
{
    NSUserDefaults *defaults = self.userDefaults;
    [defaults setBool:YES forKey:ARStartedFirstSync];
    [defaults synchronize];

    unsigned long long spaceNeeded = [self.sync estimatedNumBytesToDownload];
    double spaceOnDisk = [UIDevice bytesOfDeviceFreeSpace];

    // Enough space we think
    if (spaceNeeded < spaceOnDisk) {
        return YES;
    }

    [ARAnalytics event:ARSyncHaltedDueToSpaceEvent];
    NSString *spaceNeededString = [UIDevice humanReadableStringFromBytes:(spaceNeeded - spaceOnDisk)];
    NSString *diskSpaceWarning = [NSString stringWithFormat:@"You need %@ more disk space, please go to Settings and free space.", spaceNeededString];

    if (self.transparentModalViewController) {
        ARAlertViewController *alertVC = (ARAlertViewController *)self.transparentModalViewController;
        alertVC.alertText = diskSpaceWarning;
    }

    else {
        // a shame, Apple removed the ability to send people to settings... :(
        [self presentTransparentAlertWithText:diskSpaceWarning withOKAs:@"OK" andCancelAs:@"CANCEL" completion:^(enum ARModalAlertViewControllerStatus status) {
            if (status == ARModalAlertOK) {
                [self validateAndExitLoginScreen];
            } else {
                Partner *partner = [Partner currentPartner];
                [partner deleteEntity];

                [self dismissTransparentModalViewControllerAnimated:YES];
                [self resetWithErrorMessage:@"Cancelled due to space constraints."];
            }
        }];
    }
    return NO;
}

- (BOOL)checkForAllowingAccess
{
    if ([Partner currentPartner].limitedFolioAccessValue || [Partner currentPartner].partnerLimitedAccessValue) {
        [self presentTransparentAlertWithText:@"You don't have access to Folio" withOKAs:@"CONTACT SUPPORT" andCancelAs:@"CANCEL" completion:^(enum ARModalAlertViewControllerStatus status) {
            if (status == ARModalAlertOK) {
                MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                mailVC.subject = @"I would like to upgrade my account to include Folio";
                [self presentViewController:mailVC animated:YES completion:NULL];
                [self dismissTransparentModalViewControllerAnimated:YES];

            } else {
                Partner *partner = [Partner currentPartner];
                [partner deleteEntity];

                [self dismissTransparentModalViewControllerAnimated:YES];
                [self resetWithErrorMessage:@"Logged back out."];
            }
        }];
        return NO;
    }
    return YES;
}

- (void)loginProcessesFailedWithError:(NSString *)error
{
    [self resetWithErrorMessage:error];
}

- (void)resetWithErrorMessage:(NSString *)message
{
    // Ensure the loadView has already been called
    self.view.backgroundColor = [UIColor blackColor];
    self.errorMessageLabel.text = NSLocalizedString(message, message);
    [self reset];

    [self.userDefaults removeObjectForKey:AROAuthToken];
    [self startLoading:NO];
    [self performSelectorOnMainThread:@selector(reset) withObject:nil waitUntilDone:YES];
}

- (void)reset
{
    [self.activityIndicatorView stopAnimating];

    [UIView animateWithDuration:ARAnimationQuickDuration animations:^{
        self.loginButton.enabled = YES;
        self.loginButton.alpha = 1;
    }];
}

#pragma - UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.loginButton setEnabled:[self validatesWithMessage:NO]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self textFieldDidEndEditing:nil];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    if ([aTextField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];

    } else {
        [self login:nil];
    }
    return YES;
}

- (void)setupDefaultUsernameAndPassword
{
    if ([UIDevice isRunningUnitTests]) return;

    // In the simulator, if you have a .energy file in your
    // home directory you can set the default username and password by
    // having the contents of .energy as [email]:[password]

    NSString *initialPath = [[@"~" stringByExpandingTildeInPath] componentsSeparatedByString:@"Library"][0];
    NSString *dotFilePath = [initialPath stringByAppendingString:@".energy"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:dotFilePath]) {
        NSString *fileContents = [NSString stringWithContentsOfFile:dotFilePath
                                                           encoding:NSASCIIStringEncoding
                                                              error:nil];
        NSArray *fileComponents = [fileContents componentsSeparatedByString:@":"];

        if (fileComponents.count < 2) {
            NSLog(@"A .energy file exists but is malformed.");
            abort();
        }

        self.emailTextField.text = fileComponents[0];
        self.passwordTextField.text = fileComponents[1];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (NSUserDefaults *)userDefaults
{
    return _userDefaults ?: [NSUserDefaults standardUserDefaults];
}

- (UIApplication *)sharedApplication
{
    return _sharedApplication ?: [UIApplication sharedApplication];
}

- (ARLoginNetworkModel *)networkModel
{
    return _networkModel ?: [[ARLoginNetworkModel alloc] init];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

@end

#import "ARCMSViewController.h"
#import <WebKit/WebKit.h>
#import "ARUserManager.h"


@interface ARCMSViewController ()
@property (weak) WKWebView *webview;
@end


@implementation ARCMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *settings = [UIBarButtonItem toolbarImageButtonWithName:@"settings" withTarget:self andSelector:@selector(toggleSettingsMenu)];
    self.navigationItem.leftBarButtonItem = settings;

    UIBarButtonItem *exit = [UIBarButtonItem toolbarImageButtonWithName:@"settings" withTarget:self andSelector:@selector(goBackToFolio)];
    self.navigationItem.rightBarButtonItem = exit;

    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    [webView alignToView:self.view];
    webView.navigationDelegate = self;
    self.webview = webView;

    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:ARBaseCMSURL]];
    [webView loadRequest:req];
}

- (void)goBackToFolio
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toggleSettingsMenu
{
    [self toggleSettingsMenu:YES];
}

- (void)toggleSettingsMenu:(BOOL)animated
{
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"ARSettings" bundle:nil];
    UIViewController *settingsViewController = [settingsStoryboard instantiateInitialViewController];

    settingsViewController.modalTransitionStyle = [UIDevice isPad] ? UIModalTransitionStyleCrossDissolve : UIModalTransitionStyleCoverVertical;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;

    [self presentViewController:settingsViewController animated:animated completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if ([[[webView URL] host] isEqualToString:@"api.artsy.net"]) {
        [self runLoginScript];
    } else {
        NSLog(@"URL: %@", [webView URL]);
    }
}


- (void)runLoginScript
{
    ARUserManager *userManager = [[ARUserManager alloc] init];

    NSString *lineOne = [NSString stringWithFormat:@"document.getElementsByName('user[email]')[0].value = '%@';", userManager.email];
    NSString *lineTwo = [NSString stringWithFormat:@"document.getElementsByName('user[password]')[0].value = '%@';", userManager.password];
    NSString *lineThree = @"document.getElementsByTagName('form')[0].submit();";

    NSString *js = [NSString stringWithFormat:@"%@%@%@", lineOne, lineTwo, lineThree];
    [self.webview evaluateJavaScript:js completionHandler:NULL];
}

@end

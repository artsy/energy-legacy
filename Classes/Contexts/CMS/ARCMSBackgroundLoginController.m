#import "ARCMSBackgroundLoginController.h"
#import "ARUserManager.h"


@interface ARCMSBackgroundLoginController ()

@property (strong, readonly) WKWebView *webview;
@property (copy, readonly) NSString *email;
@property (copy, readonly) NSString *pass;

@end


@implementation ARCMSBackgroundLoginController

static ARCMSBackgroundLoginController *singleton;

+ (void)loginWithWebView:(WKWebView *)webview email:(NSString *)email password:(NSString *)pass
{
    singleton = [[ARCMSBackgroundLoginController alloc] initWithWebView:webview email:email password:pass];
    [singleton login];
}

- (instancetype)initWithWebView:(WKWebView *)webview email:(NSString *)email password:(NSString *)pass
{
    self = [super init];
    if (!self) return self;

    _pass = pass;
    _email = email;

    _webview = webview;
    _webview.navigationDelegate = self;

    return self;
}

- (void)login
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:ARBaseURL]];
    [self.webview loadRequest:req];
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

    NSString *lineOne = [NSString stringWithFormat:@"document.getElementsByName('user[email]')[0].value = '%@';", self.email];
    NSString *lineTwo = [NSString stringWithFormat:@"document.getElementsByName('user[password]')[0].value = '%@';", self.pass];
    NSString *lineThree = @"document.getElementsByTagName('form')[0].submit();";

    NSString *js = [NSString stringWithFormat:@"%@%@%@", lineOne, lineTwo, lineThree];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError *_Nullable error){

    }];
}

@end

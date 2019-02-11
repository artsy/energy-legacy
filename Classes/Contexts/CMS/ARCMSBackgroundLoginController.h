#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ARCMSBackgroundLoginController : NSObject <WKNavigationDelegate>

+ (void)loginWithWebView:(WKWebView *)webview email:(NSString *)email password:(NSString *)pass;

@end
NS_ASSUME_NONNULL_END

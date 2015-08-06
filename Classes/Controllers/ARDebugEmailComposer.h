#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface ARDebugEmailComposer : NSObject
+ (void)createEmailWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate;
@end

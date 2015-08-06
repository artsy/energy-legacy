#import <MessageUI/MFMailComposeViewController.h>
#import "AREmailSettings.h"


@interface AREmailComposer : NSObject

+ (void)emailArtworksFromViewController:(UIViewController<MFMailComposeViewControllerDelegate> *)hostviewController withEmailSettings:(AREmailSettings *)options;

@property (readonly, nonatomic, strong) AREmailSettings *options;
@property (readonly, nonatomic, copy) NSArray *documents;
@property (readonly, nonatomic, copy) NSString *subject;
@property (readonly, nonatomic, copy) NSArray *artworks;
@property (readonly, nonatomic, copy) NSArray *installationShots;

- (NSString *)subject;
- (NSString *)body;
- (NSArray *)generateCCEmails:(NSString *)emailCCString;

@end

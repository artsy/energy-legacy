#import <MessageUI/MFMailComposeViewController.h>
#import "AREmailSettings.h"

/**
 * The main responsibility of this class is to consolidate all
 * selected items from grids/detail views - then mix that with
 * the settings from an AREmailSettingsViewController and tell
 * a MFMailComposeViewControllerDelegate UIVC to show the mail
 * popover.
 *
 * From there it's on Apple.
 */
@interface AREmailComposer : NSObject

/// Generates the email, and tells the view controller to load it
+ (void)emailArtworksFromViewController:(UIViewController<MFMailComposeViewControllerDelegate> *)hostviewController withEmailSettings:(AREmailSettings *)options;

/// Custom email settings from an AREmailSettingsViewController
@property (readonly, nonatomic, strong) AREmailSettings *options;
/// Artist/Show documents
@property (readonly, nonatomic, copy) NSArray *documents;
/// The titlefor your email
@property (readonly, nonatomic, copy) NSString *subject;
/// Copies and re-orders artworks
@property (readonly, nonatomic, copy) NSArray *artworks;
/// Selected installation shots
@property (readonly, nonatomic, copy) NSArray *installationShots;

/// The generated body as HTML
- (NSString *)body;
/// Converts a comma separated string into an array of emails
- (NSArray *)generateCCEmails:(NSString *)emailCCString;

@end

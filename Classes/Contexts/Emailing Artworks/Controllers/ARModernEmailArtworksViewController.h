#import <MessageUI/MFMailComposeViewController.h>
#import <ARGenericTableViewController/ARGenericTableViewController.h>

@class AREmailSettings;


@interface ARModernEmailArtworksViewController : ARGenericTableViewController


/// Create an email artworks view controller with artworks, documents and an object that represents the current
/// context from which the controller is invoked from.

- (instancetype)initWithArtworks:(NSArray *)artworks documents:(NSArray *)documents installShots:(NSArray *)installShots context:(ARManagedObject *)context;

/// A view controller that can host the Mail Composer
@property UIViewController<MFMailComposeViewControllerDelegate> *hostViewController;

/// Does anything need to be shown?
- (BOOL)hasAdditionalOptions;

/// Creates an AREmailSettings and send it to the AREmailComposer
- (void)emailArtworks;

/// Are there mail accounts set up for the current device?
+ (BOOL)canEmailArtworks;

/// Present an alert about not having any email accounts
+ (void)presentNoMailAccountAlert;

/// An object representing the Email settings to be sent to a AREmailComposer
- (AREmailSettings *)emailSettings;

@end

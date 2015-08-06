/// Provides a view controller to present full screen messages in Folio
@interface ARFolioMessageViewController : UIViewController

/// Text for main message
@property (nonatomic, copy) NSString *messageText;

/// Subtitle for the message
@property (nonatomic, copy) NSString *callToActionText;

/// Text to be displayed on call to action button
@property (nonatomic, copy) NSString *buttonText;

/// URL to send the user to when tapping the call to action button
@property (nonatomic, copy) NSString *callToActionAddress;

/// Text to be displayed on secondary call to action button
@property (nonatomic, copy) NSString *secondaryButtonText;

/// Callback for secondary call to action button. Setting
/// this property before viewDidLoad will show the button
@property (nonatomic, copy) void (^secondaryAction)(void);

@end

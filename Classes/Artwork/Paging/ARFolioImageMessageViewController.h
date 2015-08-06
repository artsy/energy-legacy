/// Provides a view controller to present full screen messages with central image
@protocol ARFolioImageMessageViewControllerDelegate <NSObject>

- (void)dismissMessageViewController;

@end


@interface ARFolioImageMessageViewController : UIViewController

@property (nonatomic, weak) id<ARFolioImageMessageViewControllerDelegate> delegate;

/// Text for main message
@property (nonatomic, copy) NSString *messageText;

/// Text for button
@property (nonatomic, copy) NSString *buttonText;

/// Central image
@property (nonatomic, strong) UIImage *image;

/// URL to send the user on tapping the call to action
@property (nonatomic, copy) NSURL *url;

@end

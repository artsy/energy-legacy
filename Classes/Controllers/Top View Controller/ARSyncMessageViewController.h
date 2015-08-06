@class ARSync, ARSyncMessageViewController;

@protocol ARSyncMessageViewControllerDelegate <NSObject>
- (void)syncViewControllerDidFinish:(ARSyncMessageViewController *)controller;
@end


@interface ARSyncMessageViewController : UIViewController

- (instancetype)initWithMessage:(NSString *)string sync:(ARSync *)sync;

@property (readwrite, nonatomic, weak) id<ARSyncMessageViewControllerDelegate> delegate;

@end

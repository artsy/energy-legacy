#import <UIKit/UIKit.h>

@class Artwork;
@class ARViewInRoomView;
@class ARArtworkSetViewController;


@interface ARPadViewInRoomViewController : UIViewController

@property (nonatomic) Artwork *artwork;
@property (nonatomic) IBOutlet ARViewInRoomView *roomView;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic) ARArtworkSetViewController *hostView;

- (IBAction)close:(id)sender;
@end



#import "ARPadViewInRoomViewController.h"
#import "ARViewInRoomView.h"
#import "ARArtworkSetViewController.h"


@implementation ARPadViewInRoomViewController
{
    IBOutlet UIButton *closeButton;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.view.backgroundColor = [UIColor blackColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    closeButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    closeButton.titleEdgeInsets = UIEdgeInsetsMake(9, 0, 8, 0);
    _roomView.artwork = _artwork;
    _roomView.roomOrientation = self.interfaceOrientation;

    if ([UIDevice isPadPro]) {
        _roomView.frame = CGRectOffset(_roomView.frame, 0, -200);
        CGAffineTransform transform = _roomView.transform;
        _roomView.transform = CGAffineTransformScale(transform, 1.5, 1.5);
    }

    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    _roomView.roomOrientation = interfaceOrientation;
    [_roomView setNeedsLayout];
    [self.hostView willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)setArtwork:(Artwork *)anArtwork
{
    _artwork = anArtwork;
    _roomView.artwork = _artwork;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

#import "ARSyncMessageViewController.h"
#import "ARSync.h"
#import "ARProgressView.h"


@interface ARSyncMessageViewController () <ARSyncProgressDelegate, ARSyncDelegate>
@property (copy, nonatomic) NSString *message;
@property (weak, nonatomic) IBOutlet ARProgressView *progressView;
@property (weak, nonatomic) IBOutlet ARSansSerifLabel *messageLabel;
@end


@implementation ARSyncMessageViewController

- (instancetype)initWithMessage:(NSString *)message sync:(ARSync *)sync
{
    self = [super init];
    if (!self) return nil;

    _message = message;

    sync.delegate = self;
    sync.progress.delegate = self;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor artsyBackgroundColor];

    self.messageLabel.text = self.message;
    self.messageLabel.backgroundColor = [UIColor artsyBackgroundColor];
    self.messageLabel.textColor = [UIColor artsyForegroundColor];

    self.progressView.innerColor = [UIColor artsyForegroundColor];
    self.progressView.outerColor = [UIColor artsyForegroundColor];
    self.progressView.progress = 0;
}

- (void)syncDidProgress:(ARSyncProgress *)progress
{
    self.progressView.hidden = NO;
    self.progressView.progress = progress.percentDone;
}

- (void)syncDidFinish:(ARSync *)sync
{
    [self.delegate syncViewControllerDidFinish:self];
}

@end

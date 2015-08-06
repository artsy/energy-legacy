#import "ARShowViewController.h"


@interface ARShowViewController () {
    Show *_show;
}
@end


@implementation ARShowViewController

- (instancetype)initWithShow:(Show *)show
{
    if (self = [super initWithRepresentedObject:show]) {
        _show = show;

        self.title = show.presentableName ?: @"Unnamed Show";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: Why does this exist?
    self.view.clipsToBounds = YES;
}

@end

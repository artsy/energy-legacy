#import "ARButtonPopoverViewController.h"

static int ButtonMargin = 5;


@interface ARButtonPopoverViewController ()
{
    ARFlatButton *button;
    NSInteger style;
}
@end


@implementation ARButtonPopoverViewController

- (instancetype)initWithButton:(ARFlatButton *)theButton andStyle:(NSInteger)theStyle
{
    self = [super init];
    if (self) {
        button = theButton;
        style = theStyle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:button];

    self.view.bounds = button.frame;

    switch (style) {
        case ARButtonPopoverDestructive:
            [button setBackgroundColor:[UIColor colorWithRed:0.816 green:0.114 blue:0 alpha:1.0]];
            [button setBackgroundColor:[UIColor colorWithRed:0.616 green:0.086 blue:0.008 alpha:1.0] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            break;

        default:
            [button setBackgroundColor:[UIColor artsyGrayMedium]];
            [button setBackgroundColor:[UIColor artsyPurpleRegular] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(button.frame.size.width + 2 * ButtonMargin, button.frame.size.height + 4 * ButtonMargin);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

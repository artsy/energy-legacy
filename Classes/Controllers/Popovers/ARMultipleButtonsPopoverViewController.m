const static NSUInteger ButtonMargin = 5;
const static NSUInteger PopOverMinimumWidth = 100;

#import "ARMultipleButtonsPopoverViewController.h"


@implementation ARMultipleButtonsPopoverViewController {
    NSArray *_buttons;
}

- (instancetype)initWithButtons:(NSArray *)buttons
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _buttons = buttons;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self setupButtons:_buttons inPopoverView:self.view];
}

- (void)setupButtons:(NSArray *)buttons inPopoverView:(UIView *)popoverView
{
    for (UIButton *button in buttons) {
        NSUInteger index = [buttons indexOfObject:button];
        CGRect frame = button.frame;
        CGFloat currentOriginY = ButtonMargin + index * (CGRectGetHeight(frame) + ButtonMargin);

        CGRect newFrame = {
            .origin.x = ButtonMargin,
            .origin.y = currentOriginY,
            .size.width = CGRectGetWidth(frame),
            .size.height = CGRectGetHeight(frame)};

        button.frame = newFrame;
        [popoverView addSubview:button];
    }
}

- (CGSize)contentSizeForButtonsInPopover:(NSArray *)buttons
{
    CGFloat width = PopOverMinimumWidth;
    CGFloat totalHeight = ButtonMargin;

    for (UIButton *button in buttons) {
        totalHeight += CGRectGetHeight(button.frame);
        totalHeight += ButtonMargin;

        // set new maximum width if necessary
        CGFloat currentWidth = (2 * ButtonMargin) + CGRectGetWidth(button.frame);
        width = (currentWidth <= width) ? width : currentWidth;
    }

    return CGSizeMake(width, totalHeight);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (CGSize)preferredContentSize
{
    return [self contentSizeForButtonsInPopover:_buttons];
}

@end

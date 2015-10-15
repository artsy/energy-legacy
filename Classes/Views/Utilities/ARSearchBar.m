#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>

#import "ARSearchBar.h"
#import "ARFlatButton.h"

CGFloat ViewHeight = 28;
CGFloat ViewMargin = 8;
CGFloat TextfieldLeftMargin = 20;

CGFloat CancelAnimationDistance = 80;


@interface ARSearchBar () {
    UITextField *_foundSearchTextField;
    UIButton *_overlayCancelButton;
}
@end


@implementation ARSearchBar

- (UIView *)container
{
    return self.subviews.firstObject;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:_foundSearchTextField];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Find the textfield in searchbar's subviews
    for (NSInteger i = [self.container.subviews count] - 1; i >= 0; i--) {
        UIView *subview = (self.container.subviews)[i];

        if ([subview.class isSubclassOfClass:[UITextField class]]) {
            _foundSearchTextField = (UITextField *)subview;
        }
    }

    [self stylizeSearchTextField];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeOriginalCancel) name:UITextFieldTextDidBeginEditingNotification object:_foundSearchTextField];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height = ViewHeight + (ViewMargin * 2) + 4;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // resize textfield
    CGRect frame = _foundSearchTextField.frame;
    frame.size.height = ViewHeight;
    frame.origin.y = ViewMargin;
    frame.origin.x = ViewMargin;
    frame.size.width -= ViewMargin / 2;
    _foundSearchTextField.frame = frame;
}

- (void)stylizeSearchTextField
{
    // remove things like the loupe & placeholder textfield
    for (NSInteger i = [_foundSearchTextField.subviews count] - 1; i >= 0; i--) {
        UIView *subview = _foundSearchTextField.subviews[i];
        [subview setHidden:YES];
    }

    // now change the search
    _foundSearchTextField.borderStyle = UITextBorderStyleNone;
    _foundSearchTextField.backgroundColor = [UIColor whiteColor];
    _foundSearchTextField.background = [UIImage imageNamed:@"White"];
    _foundSearchTextField.text = @"";
    _foundSearchTextField.clearButtonMode = UITextFieldViewModeNever;
    _foundSearchTextField.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TextfieldLeftMargin, 0)];
    _foundSearchTextField.placeholder = @"";
    _foundSearchTextField.font = [UIFont serifFontWithSize:ARFontSansLarge];
    _foundSearchTextField.accessibilityLabel = @"Search Textfield";
    _foundSearchTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    _foundSearchTextField.tintColor = [UIColor artsyPurple];

    // Hide the grey background normally associated with ios7 searchbars
    for (NSInteger i = [self.container.subviews count] - 1; i >= 0; i--) {
        UIView *subview = (self.container.subviews)[i];
        NSString *stringClass = NSStringFromClass(subview.class);

        if ([stringClass isEqualToString:@"UISearchBarBackground"]) {
            subview.alpha = 0;
        }
    }
}

- (void)createButton
{
    ARFlatButton *cancelButton = [ARFlatButton buttonWithType:UIButtonTypeCustom];
    [[cancelButton titleLabel] setFont:[UIFont sansSerifFontWithSize:ARFontSansSmall]];

    NSString *title = [@"Cancel" uppercaseString];
    [cancelButton setTitle:title forState:UIControlStateNormal];
    [cancelButton setTitle:title forState:UIControlStateHighlighted];
    cancelButton.accessibilityLabel = @"Cancel Search";

    CGRect buttonFrame = cancelButton.frame;
    buttonFrame.origin.y = ViewMargin - 1;
    buttonFrame.size.height = ViewHeight;
    buttonFrame.size.width = 66;
    buttonFrame.origin.x = self.frame.size.width - buttonFrame.size.width - ViewMargin + CancelAnimationDistance;
    cancelButton.frame = buttonFrame;
    [cancelButton addTarget:self action:@selector(cancelSearchField) forControlEvents:UIControlEventTouchUpInside];

    _overlayCancelButton = cancelButton;
    [self addSubview:_overlayCancelButton];
    [self bringSubviewToFront:_overlayCancelButton];
}

#pragma mark deal with the cancel button

- (void)setupCancelButton
{
    [self createButton];
}

- (void)showCancelButton:(BOOL)show
{
    CGFloat distance = show ? -CancelAnimationDistance : CancelAnimationDistance;
    [UIView animateWithDuration:0.25 animations:^{
        _overlayCancelButton.frame = CGRectOffset(_overlayCancelButton.frame, distance, 0);
    }];
}

- (void)removeOriginalCancel
{
    // Remove the original button

    UIView *container = self.subviews.firstObject;
    for (NSInteger i = [container.subviews count] - 1; i >= 0; i--) {
        UIView *subview = container.subviews[i];
        NSString *stringClass = NSStringFromClass(subview.class);

        if ([stringClass isEqualToString:@"UINavigationButton"]) {
            if (subview.frame.size.height != ViewHeight) {
                subview.hidden = YES;
            }
        }
    }
}

- (void)cancelSearchField
{
    // Tap the original button!

    UIView *container = self.subviews.firstObject;
    for (NSInteger i = [container.subviews count] - 1; i >= 0; i--) {
        UIView *subview = container.subviews[i];
        NSString *stringClass = NSStringFromClass(subview.class);

        if ([stringClass isEqualToString:@"UINavigationButton"]) {
            UIButton *realCancel = (UIButton *)subview;
            [realCancel sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

@end

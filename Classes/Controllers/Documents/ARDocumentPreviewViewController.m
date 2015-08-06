//
//  This is not the Document Grid View Controller
//

// Large amounts of code were taken from ARBaseViewController because
// there's no multiple heirarchy in objc.

// This uses iOS5 APIs for laying out the view positioning.
// and I think some of the Quicklook stuff is iOS5 only too.

#import "ARDocumentPreviewViewController.h"
#import "ARTitleLabel.h"
#import "ARNavigationBar.h"


@interface QLPreviewController (PrivateFunctionsWeShouldBeRustled)
- (void)previewItemAtIndex:(NSInteger)index;
@end


@interface ARDocumentPreviewViewController ()

@property (readonly, nonatomic, strong) Document *document;
@property (readonly, nonatomic, weak) UILabel *titleView;
@property (readonly, nonatomic, weak) UIButton *customActionButton;
@property (readonly, nonatomic, weak) UIView *actionButtonBackground;
@property (readonly, nonatomic, assign) NSInteger currentIndex;
@property (readwrite, nonatomic, strong) id previewObject;

@end


@implementation ARDocumentPreviewViewController

- (instancetype)initWithDocument:(Document *)document
{
    self = [super init];
    if (!self) return nil;

    _document = document;
    _previewObject = document;

    NSString *source = [self.document isKindOfClass:[ArtistDocument class]] ? ARArtistPage : ARShowPage;
    [ARAnalytics event:ARDocumentViewEvent withProperties:@{ @"from" : source }];

    self.delegate = self;
    self.dataSource = self;

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    ARNavigationBar *bar = (ARNavigationBar *)self.navigationController.navigationBar;
    bar.suppressAddingAppleNavButtons = YES;

    [super viewWillAppear:animated];

    [self updateBottomToolbar];
    [self updateTitleStyle];
    [self updateTitleText];
    [self updateActionButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateActionButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    ARNavigationBar *bar = (ARNavigationBar *)self.navigationController.navigationBar;
    bar.suppressAddingAppleNavButtons = NO;

    [super viewWillDisappear:animated];

    [UIView animateIf:animated duration:ARAnimationDuration:^{
        self.actionButtonBackground.alpha = 0;
    } completion:^(BOOL finished) {
        // We have to leave the _actionButtonBackground behind
        // if we removeFromSuperview the navigation bar shakes in iOS5

        // In testing it's not affected anything else in the app, but
        // I'm not 100%
        
        [self.customActionButton removeFromSuperview];
        self.actionButtonBackground.hidden = YES;
        [bar tintColorDidChange];
    }];
}

// Danger Will Robinson, this is overriding a private Apple function

- (void)previewItemAtIndex:(NSInteger)index
{
    [self updateActionButton];
    [self updateTitleText];
    [super previewItemAtIndex:self.currentIndex];
}

- (void)setCurrentPreviewItemIndex:(NSInteger)currentPreviewItemIndex
{
    _currentIndex = currentPreviewItemIndex;
    [super setCurrentPreviewItemIndex:currentPreviewItemIndex];
}

- (void)updateBottomToolbar
{
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)updateTitleText
{
    self.title = [self.document.presentableFileName uppercaseString];
    self.titleView.text = self.title;
}

- (void)updateTitleStyle
{
    ARTitleLabel *titleLabel = [[ARTitleLabel alloc] initWithFrame:CGRectZero];
    _titleView = titleLabel;

    self.titleView.text = [self.title uppercaseString];
    [self.titleView sizeToFit];

    self.navigationItem.titleView = self.titleView;
}

// The action button is the button that Apple provides. We want to replace it with our own.
// Here's the constraints:

//  Cannot remove the button    - doing so would mean we can't use apple's popover
//  Cannot hide the UIBarButton - doing so does nothing, especially when people
//                                switch between documents.

- (void)updateActionButton
{
    NSInteger _actionButtonBackgroundTag = 15325;

    // It won't always be there, so it's better to
    // not add our own if a button doesn't exist
    if (self.navigationItem.rightBarButtonItem) {
        [self.navigationItem.rightBarButtonItem setImage:nil];

        if (!self.customActionButton) {
            // Create our own button, add it to the NavBar, not using the official
            // API for the barbutton items as it gets replaced.

            // As we can't remove the view without causing the nav buttons to jump in iOS5
            // we look to see if there's a hidden background already in the nav
            // so that we're not constantly adding new views to the nav

            _actionButtonBackground = [self.navigationController.navigationBar viewWithTag:_actionButtonBackgroundTag];
            if (!self.actionButtonBackground) {
                // Make a black background for the view to sit on
                UIView *actionButtonBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 72)];
                actionButtonBackground.backgroundColor = [UIColor clearColor];
                actionButtonBackground.tag = _actionButtonBackgroundTag;
                actionButtonBackground.alpha = 0;
                _actionButtonBackground = actionButtonBackground;

                [self.navigationController.navigationBar insertSubview:self.actionButtonBackground atIndex:999];
            }


            // We need to call the original, since ios7 this selector gets caught in the validator
            SEL selector = NSSelectorFromString([@"actionButton" stringByAppendingString:@"Tapped:"]);
            if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

                _customActionButton = [UIButton folioImageButtonWithName:@"Action" withTarget:self andSelector:selector];

#pragma clang diagnostic pop

                self.customActionButton.backgroundColor = [UIColor artsyBackgroundColor];
                self.customActionButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

                [self.actionButtonBackground addSubview:self.customActionButton];

                CGFloat yOffset = [UIDevice isPad] ? 14 : 0;
                self.customActionButton.frame = CGRectMake(CGRectGetWidth(self.actionButtonBackground.bounds) - 44 - 14, yOffset, 44, 44);

                self.actionButtonBackground.hidden = NO;
                [UIView animateWithDuration:ARAnimationDuration animations:^{
                    self.actionButtonBackground.alpha = 1;
                }];
            }
        }

        // This will ensure it's always in the top right
        CGRect buttonFrame = self.actionButtonBackground.frame;
        buttonFrame.origin.x = self.navigationController.navigationBar.bounds.size.width - buttonFrame.size.width;
        buttonFrame.origin.y = 0;
        self.actionButtonBackground.frame = buttonFrame;
    }
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark QLPreviewControllerDelegate

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self.previewObject;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

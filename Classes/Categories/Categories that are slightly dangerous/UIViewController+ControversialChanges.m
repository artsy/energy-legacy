// The title code is mine, the back button is based on
// http://justabeech.com/2014/02/24/empty-back-button-on-ios7/

#import <objc/runtime.h>


@interface UIViewController (ControversialChanges)
- (void)swappedSetTitle:(NSString *)title;
- (void)swappedViewDidLoad;
@end


@implementation UIViewController (ControversialChanges)

+ (void)initialize
{
    if (self == [UIViewController class]) {
        [self setup];
    }
}

+ (void)setup
{
    Method originalTitleMethod = class_getInstanceMethod(self, @selector(setTitle:));
    Method swappedTitleMethod = class_getInstanceMethod(self, @selector(swappedSetTitle:));

    method_exchangeImplementations(originalTitleMethod, swappedTitleMethod);

    Method originalLoadMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
    Method swizzledLoadMethod = class_getInstanceMethod(self, @selector(swappedViewDidLoad));

    method_exchangeImplementations(originalLoadMethod, swizzledLoadMethod);
}

- (void)swappedSetTitle:(NSString *)title
{
    title = title.uppercaseString;
    [self swappedSetTitle:title];
}

- (void)swappedViewDidLoad
{
    [self swappedViewDidLoad];

    if (![UIDevice isPad]) {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButtonItem];
    }
}


@end

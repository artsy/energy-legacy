#import <UIKit/UIKit.h>


@interface ARSearchBar : UISearchBar

- (void)setupCancelButton;

// Called from The SearchDisplayController Delegate
- (void)showCancelButton:(BOOL)show;

- (void)cancelSearchField;
@end

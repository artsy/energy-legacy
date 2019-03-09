#import <UIKit/UIKit.h>

/// A tick which fills itself in pretty elegantly. I remember
/// spending 2 evenings in a row progrmming in my sisters' room
/// hand animating this to make it really shine.
///
@interface ARAnimatedTickView : UIView

/// Default init
- (instancetype)initWithSelection:(BOOL)selected;

/// Whether it's on or off
- (BOOL)selected;

/// Animate the state
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/// Defaults to Artsy Purple, but lets you change the fill color
- (void)setHighlightColor:(UIColor *)color;
@end

#import <UIKit/UIKit.h>

// Could be one stack, could be two, same API, distributes views between the splits


@interface ARAmbiguousSplitStackView : UIView

/// Should it be one or two stacks?
@property (nonatomic, assign) BOOL isSplit;

/// The distance between stacks
@property (nonatomic, assign) CGFloat centerMargin;

/// Number of items inserted before switching to a different stackview, defaults to 1.
@property (nonatomic, assign) NSUInteger itemsPerSplitToggle;

// Emulates a subset of the ORStackView API

- (void)addSubview:(UIView *)view withPrecedingMargin:(CGFloat)margin;

- (void)addSubview:(UIView *)view withPrecedingMargin:(CGFloat)topMargin sideMargin:(CGFloat)sideMargin;

// Ensure people don't make mistakes

- (void)addSubview:(UIView *)view __attribute__((unavailable("addSubview is not supported on ARAmbiguousSplitStackView.")));

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index __attribute__((unavailable("insertSubview is not supported on ARAmbiguousSplitStackView.")));

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview __attribute__((unavailable("insertSubview is not supported on ARAmbiguousSplitStackView.")));

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview __attribute__((unavailable("insertSubview is not supported on ORStacARAmbiguousSplitStackViewkView.")));

@end

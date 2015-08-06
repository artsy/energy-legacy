#import "ARDashedHighlightView.h"

static NSInteger ViewTag = 232312;

// the right side is smaller to account for the 2px border
static const UIEdgeInsets Insets = {.top = -4, .left = -6, .bottom = -4, .right = -4};


@implementation ARDashedHighlight

+ (void)highlightView:(UIView *)targetView animated:(BOOL)animated
{
    UIView *view = [[UIView alloc] initWithFrame:targetView.bounds];
    if (view) {
        view.frame = UIEdgeInsetsInsetRect(view.frame, Insets);

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        CGRect shapeRect = view.bounds;
        [shapeLayer setBounds:shapeRect];

        // the +1's are to ensure the lines aren't cropped
        [shapeLayer setPosition:CGPointMake((view.bounds.size.width / 2) + 1, (view.bounds.size.height / 2) + 1)];

        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        [shapeLayer setStrokeColor:[[UIColor darkGrayColor] CGColor]];
        [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        [shapeLayer setLineDashPattern:@[ @2, @2 ]];

        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, shapeRect);
        [shapeLayer setPath:path];
        CGPathRelease(path);

        [view.layer addSublayer:shapeLayer];
        view.tag = ViewTag;

        [targetView addSubview:view andFadeInForDuration:ARAnimationQuickDuration if:animated];
    }
}

+ (void)removeHighlight:(UIView *)targetView animated:(BOOL)animated
{
    UIView *view = [targetView viewWithTag:ViewTag];
    if (view) {
        [view removeFromSuperviewAndFadeOutWithDuration:ARAnimationQuickDuration if:animated];
    }
}

@end

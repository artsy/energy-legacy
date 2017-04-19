#import "ARProgressView.h"


@implementation ARProgressView

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    [self setup];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.innerColor = [UIColor whiteColor];
    self.outerColor = [UIColor whiteColor];
    self.progress = 0;
    self.radius = 0;
}

- (void)setProgress:(CGFloat)theProgress
{
    _progress = MAX(MIN(theProgress, 1), 0);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // save the context
    CGContextSaveGState(context);

    // allow antialiasing
    CGContextSetAllowsAntialiasing(context, TRUE);

    // we first draw the outter rounded rectangle
    rect = CGRectInset(rect, 1.0f, 1.0f);
    CGFloat radius = self.radius == NSNotFound ? 0.5f * rect.size.height : self.radius;

    [self.outerColor setStroke];
    CGContextSetLineWidth(context, 2.0f);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);

    // draw the empty rounded rectangle (shown for the "unfilled" portions of the progress
    rect = CGRectInset(rect, 3.0f, 3.0f);
    radius = self.radius == NSNotFound ? 0.5f * rect.size.height : self.radius;

    [self.emptyColor setFill];

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    CGContextClosePath(context);
    CGContextFillPath(context);

    // draw the inside moving filled rounded rectangle
    radius = self.radius == NSNotFound ? 0.5f * rect.size.height : self.radius;

    // make sure the filled rounded rectangle is not smaller than 2 times the radius
    rect.size.width *= self.progress;
    if (rect.size.width < 2 * radius)
        rect.size.width = 2 * radius;

    [self.innerColor setFill];

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    CGContextClosePath(context);
    CGContextFillPath(context);

    // restore the context
    CGContextRestoreGState(context);
}

@end

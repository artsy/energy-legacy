#import "ARBorderedSerifLabel.h"
#import "AROptions.h"


@implementation ARBorderedSerifLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    UIView *topBorder = [[UIView alloc] initWithFrame:frame];
    topBorder.backgroundColor = [UIColor artsySingleLineGrey];
    [self addSubview:topBorder];
    [topBorder constrainHeight:@"1"];
    [topBorder alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self];

    UIView *bottomBorder = [[UIView alloc] initWithFrame:frame];
    bottomBorder.backgroundColor = [UIColor artsySingleLineGrey];
    [self addSubview:bottomBorder];
    [bottomBorder constrainHeight:@"1"];
    [bottomBorder alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self];

    _label = [[ARSerifLabel alloc] initWithFrame:frame];
    _label.backgroundColor = [UIColor artsyBackgroundColor];

    BOOL whiteFolio = [AROptions boolForOption:AROptionsUseWhiteFolio];
    _label.textColor = whiteFolio ? [UIColor artsyGrayBold] : [UIColor artsyGrayMedium];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];

    [_label constrainWidthToView:self predicate:@"0"];
    [_label alignLeadingEdgeWithView:self predicate:@"0"];
    [_label alignCenterYWithView:self predicate:@"0"];

    self.backgroundColor = [UIColor artsyBackgroundColor];
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, self.label.intrinsicContentSize.height + 40);
}

@end

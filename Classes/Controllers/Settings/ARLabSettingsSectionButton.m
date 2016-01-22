#import "ARLabSettingsSectionButton.h"


@interface ARLabSettingsSectionButton ()

@property (weak, nonatomic) IBOutlet UILabel *settingTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *topBorder;
@property (weak, nonatomic) IBOutlet UIView *bottomBorder;
@property (weak, nonatomic) IBOutlet UIImageView *chevron;
@property (weak, nonatomic) IBOutlet UIImageView *alertBadge;

@end


@implementation ARLabSettingsSectionButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    NSString *className = NSStringFromClass(self.class);
    self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    [self addSubview:self.view];

    self.alertBadge.hidden = YES;

    return self;
}

- (void)setTitle:(NSString *)title
{
    [self.settingTitleLabel setText:title.uppercaseString];
}

- (void)setTitleTextColor:(UIColor *)color
{
    [self.settingTitleLabel setTextColor:color];
}

- (void)hideTopBorder
{
    self.topBorder.alpha = 0;
}

- (void)hideChevron
{
    self.chevron.alpha = 0;
}

- (void)showAlertBadge:(BOOL)show
{
    self.alertBadge.hidden = !show;
}

@end

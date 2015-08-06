#import "ARTableViewCell.h"

CGFloat ARTableViewCellSettingsHeight = 60;


@implementation ARTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self setUseSerifFont:YES];

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor artsyMediumGrey];
    self.selectedBackgroundView = backgroundView;
    self.textLabel.backgroundColor = [UIColor clearColor];

    return self;
}

- (void)setUseSerifFont:(BOOL)newUseSerifFont
{
    _useSerifFont = newUseSerifFont;

    if (_useSerifFont) {
        self.textLabel.font = [UIFont serifFontWithSize:ARFontSerif];
        self.detailTextLabel.font = [UIFont serifFontWithSize:ARFontSerif];
    } else {
        self.textLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
        self.detailTextLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    }
}

@end

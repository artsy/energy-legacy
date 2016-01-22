

#import "ARTableHeaderView.h"

static CGFloat HeightOfSearchHeaders = 40.0;
static CGFloat SearchHeadersLeftInset = 12.0;


@implementation ARTableHeaderView

+ (CGFloat)heightOfCell
{
    return HeightOfSearchHeaders;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title style:(enum ARTableHeaderViewStyle)style
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    CGFloat offset = (style == ARTableHeaderViewStyleDark) ? SearchHeadersLeftInset : 0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, CGRectGetWidth(self.frame) - offset, HeightOfSearchHeaders)];

    label.text = [title uppercaseString];
    label.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];

    switch (style) {
        case ARTableHeaderViewStyleDark:
            self.backgroundColor = [UIColor blackColor];
            self.layer.borderWidth = 3;
            self.layer.borderColor = [[UIColor whiteColor] CGColor];

            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor blackColor];

            break;

        case ARTableHeaderViewStyleLight:
            break;
    }

    [self addSubview:label];

    return self;
}

@end

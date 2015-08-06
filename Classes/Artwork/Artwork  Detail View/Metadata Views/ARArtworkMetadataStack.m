#import "ARArtworkMetadataStack.h"
#import <Artsy+UILabels/ARLabelSubclasses.h>


@implementation ARArtworkMetadataStack

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _maximumAmountOfLines = 2;

    return self;
}

- (void)setStrings:(NSArray *)strings
{
    self.bottomMarginHeight = 6;
    [self removeAllSubviews];

    // Use a compression view to ensure bottom vertical alignment

    UIView *whitespaceGobbler = [[UIView alloc] init];
    whitespaceGobbler.backgroundColor = [UIColor clearColor];
    [whitespaceGobbler setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:whitespaceGobbler withTopMargin:nil sideMargin:nil];

    [self performBatchUpdates:^{

        for (id string in strings) {
            UILabel *label = [self createLabel];
            if ([string isKindOfClass:NSString.class]) {
                label.text = string;

            } else if ([string isKindOfClass:NSAttributedString.class]) {

                label.attributedText = [self alignedAttributedString:string];
            }

            [self addSubview:label withTopMargin:@"10" sideMargin:@"0"];
        }
    }];
}

- (NSAttributedString *)alignedAttributedString:(NSAttributedString *)string
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:self.textAlignment];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];

    return attributedString;
}

- (UILabel *)createLabel
{
    UILabel *label = [[ARFolioResizingSerifLabel alloc] init];
    label.textColor = [UIColor artsyForegroundColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = self.textAlignment;
    label.opaque = NO;
    label.numberOfLines = self.maximumAmountOfLines;

    [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    return label;
}

@end

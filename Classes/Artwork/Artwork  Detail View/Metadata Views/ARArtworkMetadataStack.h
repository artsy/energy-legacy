#import <ORStackView/ORStackView.h>


@interface ARArtworkMetadataStack : ORStackView

- (void)setStrings:(NSArray *)strings;

@property (nonatomic, assign) NSTextAlignment textAlignment;

/// Max amount of lines each string can have, defaults to 2
@property (readwrite, nonatomic, assign) CGFloat maximumAmountOfLines;

@end

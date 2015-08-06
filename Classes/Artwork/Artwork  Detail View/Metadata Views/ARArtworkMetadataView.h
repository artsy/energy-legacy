#import "ARArtworkMetadataViewable.h"


@interface ARArtworkMetadataView : UIView <ARArtworkMetadataViewable>

@property (readwrite, nonatomic, assign) BOOL needsIndicator;
@property (readwrite, nonatomic, assign) CGFloat additionalImages;

/// Max amount of string values, defaults to 4
@property (readwrite, nonatomic, assign) NSInteger maxAllowedInputs;

/// Max amount of lines each string cna has, defaults to 2
@property (readwrite, nonatomic, assign) CGFloat maximumAmountOfLines;

- (void)setStrings:(NSArray *)strings;

@end

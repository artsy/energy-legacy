#import "ARArtworkMetadataViewable.h"


@interface ARArtworkMetadataExtendedView : UIView <ARArtworkMetadataViewable>

@property (readwrite, nonatomic, assign) BOOL needsIndicator;
@property (readwrite, nonatomic, assign) CGFloat additionalImages;

/// Switches between a maximum of 2 lines of for text and infinite
@property (readwrite, nonatomic, assign, getter=isConstrainedVertically) BOOL constrainedVerticalSpace;

- (void)setStrings:(NSArray *)strings;

@end

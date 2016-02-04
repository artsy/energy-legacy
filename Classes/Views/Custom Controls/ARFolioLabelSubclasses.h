#import <Artsy_UILabels/ARLabelSubclasses.h>

/// This subclass will set it's max layout width to its bounds
/// doing so will cause a 2nd constraint render loop, so be
/// conservative in its use.


@interface ARFolioResizingSerifLabel : ARSerifLabel
@end


@interface ARFolioSerifLabel : ARSerifLabel
@end


@interface ARFolioSansSerifLabel : ARSansSerifLabel
@end

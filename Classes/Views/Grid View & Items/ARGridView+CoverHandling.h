#import "ARGridView.h"

// To keep the ARGridView focused on dealing with displaying cells
// the work to allow changing cover has it's own place.


@interface ARGridView (CoverHandling)
- (void)longPressed:(UILongPressGestureRecognizer *)recognizer;
@end

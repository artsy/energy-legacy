#import "ARGridViewCell.h"


@interface AREditableImageGridViewCell : ARGridViewCell

@property (assign, nonatomic) BOOL editingEnabled;

- (void)setEditing:(BOOL)editing animated:(BOOL)animate;

@property (strong, nonatomic, readonly) UITapGestureRecognizer *titleChangeTapGesture;
@end

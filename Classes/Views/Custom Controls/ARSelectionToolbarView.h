

@interface ARSelectionToolbarView : UIView

@property (readwrite, nonatomic, strong) NSArray *barButtonItems;

@property (readonly, nonatomic, copy) UIButton *button;
@property (readonly, nonatomic, copy) NSArray *buttons;

@property (readwrite, nonatomic, assign, getter=isAttatchedToTop) BOOL attatchedToTop;
@property (readwrite, nonatomic, assign, getter=isAttatchedToBottom) BOOL attatchedToBottom;

@property (readwrite, nonatomic, assign, getter=isHorizontallyConstrained) BOOL horizontallyConstrained;

@end

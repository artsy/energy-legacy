

@interface ARImageGridViewItem : NSObject <ARGridViewItem>

+ (instancetype)gridViewButton;

- (void)setTarget:(id)target action:(SEL)action;
- (void)performActionEvent;

@property (readwrite, nonatomic, copy) NSString *gridTitle;
@property (readwrite, nonatomic, copy) NSString *gridSubtitle;

@property (readwrite, nonatomic, assign) float aspectRatio;
@property (readonly, nonatomic, assign) BOOL isButton;

@property (readwrite, nonatomic, copy) NSString *imageFilepath;
@end



@interface ARButton : UIButton
- (void)setup;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
@end


@interface ARFlatButton : ARButton

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated;

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state;

@property (nonatomic, strong) UIColor *borderColor;
@end


@interface ARLoginFlatButton : ARFlatButton
@end


@interface ARSyncFlatButton : ARFlatButton
@end


@interface ARAlertLowVisualPriorityButton : ARFlatButton
@end


@interface ARAlertHighVisualPriorityButton : ARFlatButton
@end

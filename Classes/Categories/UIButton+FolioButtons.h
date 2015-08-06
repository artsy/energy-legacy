

@interface UIButton (FolioButtons)

+ (UIButton *)folioToolbarButtonWithTitle:(NSString *)title;
+ (UIButton *)folioUnborderedToolbarButtonWithTitle:(NSString *)title;

+ (UIButton *)folioImageButtonWithName:(NSString *)name withTarget:(id)target andSelector:(SEL)selector;
- (void)setToolbarImagesWithName:(NSString *)name;

@end

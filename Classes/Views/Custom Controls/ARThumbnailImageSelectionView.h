


@interface ARThumbnailImageSelectionView : UIScrollView

@property (readwrite, copy, nonatomic) NSArray *images;
@property (readwrite, strong, nonatomic) UIColor *borderColor;

- (NSIndexSet *)selectedIndexes;

- (void)selectAll;
@end

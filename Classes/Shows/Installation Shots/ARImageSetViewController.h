

@interface ARImageSetViewController : UIPageViewController

- (instancetype)initWithImages:(NSArray *)images atIndex:(NSInteger)index;

@property (nonatomic, copy, readonly) NSArray *images;
@property (nonatomic, assign, readonly) NSInteger index;

@end

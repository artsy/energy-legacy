@protocol ARPagingArtworkDataSource <NSObject>

- (Artwork *)artworkAtIndex:(NSInteger)index;

- (NSUInteger)artworkCount;

@end


@interface ARPagingArtworkViewController : UIPageViewController <UIPageViewControllerDataSource>

- (instancetype)initWithDelegate:(id<ARPagingArtworkDataSource>)delegate index:(NSInteger)index;

@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, weak, readonly) id<ARPagingArtworkDataSource> pagingDelegate;

@end

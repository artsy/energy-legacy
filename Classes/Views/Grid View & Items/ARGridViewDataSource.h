

@interface ARGridViewDataSource : NSObject

@property (nonatomic, copy) NSArray *prefixedObjects;
@property (readwrite, nonatomic, copy) NSString *thumbnailFormat;
@property (readwrite, nonatomic, strong) NSManagedObjectContext *cacheContext;

- (void)setResults:(NSFetchRequest *)fetchRequest;
- (NSFetchedResultsController *)resultsController;

- (NSArray *)allObjects;
- (NSInteger)numberOfItems;

- (id<ARGridViewItem>)objectAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)containsObject:(id)object;

- (CGFloat)aspectRatioForItem:(id<ARGridViewItem>)item;
- (NSURL *)imageURLForItem:(id<ARGridViewItem>)item;
- (NSString *)imagePathForItem:(id<ARGridViewItem>)item;
- (NSString *)gridTitleForItem:(id<ARGridViewItem>)item;
- (NSString *)gridSubtitleForItem:(id<ARGridViewItem>)item;
- (BOOL)isButton:(id<ARGridViewItem>)item;

@end

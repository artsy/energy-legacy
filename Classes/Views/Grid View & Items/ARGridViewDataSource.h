


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

// These are all cached item lookups for the current screen

- (CGFloat)aspectRatioForItem:(id<ARGridViewItem>)item;
- (NSURL *)imageURLForItem:(id<ARGridViewItem>)item;
- (NSString *)imagePathForItem:(id<ARGridViewItem>)item;
- (NSString *)gridTitleForItem:(id<ARGridViewItem>)item;
- (NSAttributedString *)gridAttributedSubtitleForItem:(id<ARGridViewItem>)item;
- (NSString *)gridSubtitleForItem:(id<ARGridViewItem>)item;

/// For special cases (like the + for a new album)
- (BOOL)isButton:(id<ARGridViewItem>)item;

@end

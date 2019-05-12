#import "NSFetchedResultsController+Count.h"
#import "ARGridView.h"
#import "ARGridViewDataSource.h"


@interface ARGridViewDataSource ()
@property (nonatomic, strong, readonly) NSMutableDictionary *cache;
@property (nonatomic, copy, readonly) dispatch_queue_t cacheQueue;
@property (nonatomic, strong, readonly) NSFetchedResultsController *itemResultController;
@end


@implementation ARGridViewDataSource

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _cache = [NSMutableDictionary dictionary];
    _cacheQueue = dispatch_queue_create("net.artsy.GridCacheQueue", NULL);
    _prefixedObjects = @[];

    return self;
}

- (void)setResults:(NSFetchRequest *)fetchRequest
{
    NSParameterAssert(fetchRequest);

    if (fetchRequest && [self shouldChangeResultsWithRequest:fetchRequest]) {
        [_cache removeAllObjects];

        NSString *cacheName = @"GridViewDataSourceCache";
        [NSFetchedResultsController deleteCacheWithName:cacheName];
        _itemResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.cacheContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:cacheName];
        NSError *error = nil;
        if (![self.itemResultController performFetch:&error]) {
            NSLog(@"Grid view results fetch failed %@", error);
        }
    }
}

- (NSFetchedResultsController *)resultsController
{
    return self.itemResultController;
}

- (NSInteger)numberOfItems
{
    return self.prefixedObjects.count + self.itemResultController.count;
}

- (NSArray *)allObjects
{
    return [self.prefixedObjects arrayByAddingObjectsFromArray:[self.itemResultController fetchedObjects]];
}

- (id<ARGridViewItem>)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.prefixedObjects.count && indexPath.row < self.prefixedObjects.count) {
        return self.prefixedObjects[indexPath.row];
    } else {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:indexPath.row - self.prefixedObjects.count inSection:indexPath.section];
        return [self.itemResultController objectAtIndexPath:newPath];
    }
}

- (BOOL)containsObject:(id)object
{
    return [self.itemResultController indexPathForObject:object] != nil && [self.prefixedObjects containsObject:object];
}

- (id)getCachedValueForKey:(NSString *)key forItem:(id<ARGridViewItem>)item
{
    NSString *tempId = [(ARManagedObject *)item tempId];
    NSDictionary *record = [_cache objectForKey:tempId];
    if (!record) {
        return nil;
    }
    return [record objectForKey:key];
}

- (void)setCachedValue:(id)val forKey:(NSString *)key forItemId:(NSString *)slug
{
    if (!val) return;

    NSMutableDictionary *record = [_cache objectForKey:slug];
    if (!record) {
        record = [NSMutableDictionary dictionary];
        [_cache setObject:record forKey:slug];
    }
    [record setObject:val forKey:key];
}

static NSString *ARAspectRatioKey = @"AspectRatio";
static NSString *ARImagePathKey = @"ImagePath";
static NSString *ARImageURLKey = @"ImageURL";
static NSString *ARTitleKey = @"Title";
static NSString *ARSubtitleKey = @"Subtitle";

- (CGFloat)aspectRatioForItem:(id<ARGridViewItem>)item
{
    NSNumber *cachedRatio = [self getCachedValueForKey:ARAspectRatioKey forItem:item];
    if (cachedRatio) {
        return [cachedRatio floatValue];
    }

    CGFloat ratio = [item aspectRatio];
    NSString *tempId = [(ARManagedObject *)item tempId];
    [self setCachedValue:[NSNumber numberWithFloat:ratio] forKey:ARAspectRatioKey forItemId:tempId];
    return ratio;
}

- (NSURL *)imageURLForItem:(id<ARGridViewItem>)item
{
    NSURL *url = [self getCachedValueForKey:ARImageURLKey forItem:item];
    if (url) {
        return url;
    }

    NSString *tempId = [(ARManagedObject *)item tempId];
    url = [item gridThumbnailURL:self.thumbnailFormat];

    [self setCachedValue:url forKey:ARImageURLKey forItemId:tempId];
    return url;
}

- (NSString *)imagePathForItem:(id<ARGridViewItem>)item
{
    NSString *path = [self getCachedValueForKey:ARImagePathKey forItem:item];
    if (path) {
        return path;
    }
    path = [item gridThumbnailPath:self.thumbnailFormat];
    NSString *tempId = [(ARManagedObject *)item tempId];

    [self setCachedValue:path forKey:ARImagePathKey forItemId:tempId];
    return path;
}

- (NSString *)gridTitleForItem:(id<ARGridViewItem>)item
{
    NSString *title = [self getCachedValueForKey:ARTitleKey forItem:item];
    if (title) {
        return title;
    }
    title = [item gridTitle];
    NSString *tempId = [(ARManagedObject *)item tempId];
    [self setCachedValue:title forKey:ARTitleKey forItemId:tempId];
    return title;
}

- (NSString *)gridSubtitleForItem:(id<ARGridViewItem>)item
{
    NSString *subtitle = [self getCachedValueForKey:ARSubtitleKey forItem:item];
    if (subtitle) {
        return subtitle;
    }

    subtitle = [item gridSubtitle];
    NSString *tempId = [(ARManagedObject *)item tempId];
    [self setCachedValue:subtitle forKey:ARSubtitleKey forItemId:tempId];
    return subtitle;
}

- (NSAttributedString *)gridAttributedSubtitleForItem:(id<ARGridViewItem>)item
{
    NSAttributedString *subtitle = [self getCachedValueForKey:ARSubtitleKey forItem:item];
    if (subtitle) {
        return subtitle;
    }

    subtitle = [item attributedGridSubtitle];
    NSString *tempId = [(ARManagedObject *)item tempId];
    [self setCachedValue:subtitle forKey:ARSubtitleKey forItemId:tempId];
    return subtitle;
}


// The slug will tell you if an item conforming to ARGridViewItem protocol is a button
- (BOOL)isButton:(id<ARGridViewItem>)item
{
    if ([[item slug] isEqualToString:@"grid_view_button"]) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldChangeResultsWithRequest:(NSFetchRequest *)request
{
    // This didn't work, there are times when we need to refresh the grid
    // but not because of the data changing, ideally ^ could have a force param?
    //
    //    BOOL hasChanges = [self.resultsController.fetchRequest includesPendingChanges];
    //    BOOL sameRequest = [self.resultsController.fetchRequest isEqual:request];
    //    return (!sameRequest || hasChanges);
    return YES;
}


@end

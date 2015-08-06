#import "ARSimpleImageGridViewDataSource.h"


@implementation ARSimpleImageGridViewDataSource


- (NSArray *)allObjects
{
    return self.imageItems;
}

- (NSInteger)numberOfItems
{
    return self.imageItems.count;
}

- (id<ARGridViewItem>)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self.imageItems[indexPath.row];
}

- (BOOL)containsObject:(id)object
{
    return [self.imageItems containsObject:object];
}

- (CGFloat)aspectRatioForItem:(id<ARGridViewItem>)item
{
    return item.aspectRatio;
}

- (NSURL *)imageURLForItem:(id<ARGridViewItem>)item
{
    return nil;
}

- (NSString *)imagePathForItem:(id<ARGridViewItem>)item;
{
    return [item gridThumbnailPath:nil];
}

- (NSString *)gridTitleForItem:(id<ARGridViewItem>)item
{
    return item.gridTitle;
}

- (NSString *)gridSubtitleForItem:(id<ARGridViewItem>)item
{
    return item.gridSubtitle;
}

@end

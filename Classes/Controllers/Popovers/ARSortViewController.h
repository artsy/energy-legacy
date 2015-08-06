@class ARSortDefinition;

@protocol ARSortViewControllerDelegate <NSObject>
- (void)newSortWasSelected:(ARSortDefinition *)sort;
@end

/// Presents a popover of available sorts, and lets its delegate know when a new one was selected.


@interface ARSortViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithSorts:(NSArray *)sorts andSelectedIndex:(NSInteger)selectedIndex;

@property (nonatomic, weak) NSObject<ARSortViewControllerDelegate> *delegate;

@end

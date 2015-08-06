#import "ARGridViewItem.h"
#import "ARPopoverController.h"

@class ARGridView, Artwork, ARGridViewCell, ARGridViewDataSource, ARSelectionHandler;

@protocol ARGridViewDelegate <NSObject>
@optional
- (void)removeArtworkFromAlbum:(id<ARGridViewItem>)item completion:(dispatch_block_t)completion;
- (BOOL)isHostingShow;
- (BOOL)isHostingEditableAlbum;
- (BOOL)isHostingLocation;

@required
- (void)gridViewDidScroll:(ARGridView *)gridView;
- (void)gridView:(ARGridView *)gridView didSelectItem:(id<ARGridViewItem>)anItem atIndex:(NSInteger)index;
- (BOOL)gridView:(ARGridView *)gridView canSelectItem:(id<ARGridViewItem>)anItem atIndex:(NSInteger)index;
- (void)gridView:(ARGridView *)gridView didDeselectItem:(id<ARGridViewItem>)anItem atIndex:(NSInteger)index;
- (void)setCover:(Image *)cover;
@end


@interface ARGridView : UIView <UIScrollViewDelegate, WYPopoverControllerDelegate>

- (instancetype)initWithDisplayMode:(enum ARDisplayMode)initialDisplayMode;

/// Objects that conform to ARGridViewItem that are added before the main datasource's items - animates
@property (nonatomic, copy) NSArray *prefixedObjects;

/// Sets prefixed objects optionally without an argument
- (void)setPrefixedObjects:(NSArray *)prefixedObjects animated:(BOOL)animated;

/// Delegate of user interactions
@property (nonatomic, weak) id<ARGridViewDelegate> delegate;

/// The display mode of the the ARGridView
@property (nonatomic, assign) enum ARDisplayMode displayMode;

/// A source for getting ARGridViewItems, similar API to tableviews
@property (readonly, nonatomic, strong) ARGridViewDataSource *dataSource;

/// Are the items being editied ( e.g. in the All Albums page ) - animated
@property (nonatomic, assign) BOOL editing;

/// Sets whether items are being edited
- (void)setEditing:(BOOL)isEditing animated:(BOOL)animated;

/// Title which shows above the items in on the phone
@property (readwrite, nonatomic, copy) NSString *title;

/// The fetch result that get's set on the datasource
/// TODO? Could this just be bypassed?
- (void)setResults:(NSFetchRequest *)fetchRequest;

/// NSManagedObjectContext for storing the cache data
- (void)setCacheContext:(NSManagedObjectContext *)cacheContext;

/// Is the ARGridView in multi-selection?
@property (nonatomic, assign, readonly) BOOL isSelectable;

/// Toggle multi-selection mode
- (void)setIsSelectable:(BOOL)selectable animated:(BOOL)animate;

/// Selection Handler, nil defaults to ARSelectionHandler sharedHandler
@property (nonatomic, strong) ARSelectionHandler *selectionHandler;

@property (nonatomic, assign) CGPoint contentOffset;

- (NSString *)thumbnailImageSize;

- (void)selectAllItems;
- (void)deselectAllItems;
- (NSArray *)selectedItems;

@end

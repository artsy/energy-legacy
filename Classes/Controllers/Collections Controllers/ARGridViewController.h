#import "ARGridView.h"
#import "ARNewAlbumModalViewController.h"
#import "ARDocumentContainer.h"
#import "ARArtworkContainer.h"

@class ARGridViewController, ARSelectionHandler;

@protocol ARGridViewControllerDelegate <NSObject>
- (void)gridViewController:(ARGridViewController *)gridViewController didHaveGridScroll:(ARGridView *)gridView;
@end


@interface ARGridViewController : UIViewController <ARGridViewDelegate, UIGestureRecognizerDelegate>

- (instancetype)initWithDisplayMode:(enum ARDisplayMode)initialDisplayMode;

@property (readwrite, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readwrite, nonatomic, strong) NSUserDefaults *userDefaults;

@property (readwrite, nonatomic, strong) ARSelectionHandler *selectionHandler;


@property (nonatomic, strong) ARGridView *gridView;
@property (nonatomic, assign) enum ARDisplayMode displayMode;
@property (nonatomic, weak) id<ARGridViewControllerDelegate> gridViewScrollDelegate;

@property (nonatomic, strong) ARManagedObject *representedObject;
@property (nonatomic, strong) ARManagedObject<ARArtworkContainer> *currentArtworkContainer;
@property (nonatomic, strong) NSObject<ARDocumentContainer> *currentDocumentContainer;
@property (nonatomic, strong) NSFetchRequest *results;

@property (nonatomic, assign) BOOL isEditing;
- (void)setIsEditing:(BOOL)newIsEditing animated:(BOOL)animate;

@property (nonatomic, assign, readonly) BOOL isSelectable;
- (void)setIsSelectable:(BOOL)isSelectable animated:(BOOL)animate;

- (void)reloadData;

- (void)selectAllItems;

- (void)deselectAllItems;

- (BOOL)allItemsAreSelected;

- (NSString *)pageID;

- (NSDictionary *)dictionaryForAnalytics;

- (void)setResults:(NSFetchRequest *)results animated:(BOOL)animated;
@end

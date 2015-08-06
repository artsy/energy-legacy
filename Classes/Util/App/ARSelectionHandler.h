/// The Selection handler is a class that keeps track of whether
/// we're selecting things, which type of selection we're in
/// and what objects are selected.


@interface ARSelectionHandler : NSObject

+ (ARSelectionHandler *)sharedHandler;

- (BOOL)isSelecting;
- (BOOL)isSelectingForEmail;
- (BOOL)isSelectingForAlbum;

- (void)startSelecting:(BOOL)selecting;
- (void)startSelectingForEmail;
- (void)startSelectingForAlbum:(Album *)album;
- (void)startSelectingForAnyAlbum;

- (NSSet *)selectedObjects;

- (void)selectObject:(ARManagedObject *)object;
- (void)selectObjects:(NSSet *)objects;

- (void)deselectObject:(ARManagedObject *)object;
- (void)deselectAllObjects;

- (void)commitSelection;
- (void)endSelectingAlbumWithSave:(BOOL)save;

// These two are identical in features
- (void)cancelSelection;

- (void)finishSelection;
@end

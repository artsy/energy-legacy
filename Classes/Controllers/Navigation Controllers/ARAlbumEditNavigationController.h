@class ARSelectionToolbarView;


@interface ARAlbumEditNavigationController : UINavigationController

- (instancetype)initWithAlbum:(Album *)album;
@property (nonatomic, strong, readonly) Album *album;

- (NSArray *)buttonsForCommitingChanges;

- (NSString *)descriptionOfSelectionState;
- (NSArray *)selectedArtworks;

- (void)saveAlbum;
- (void)cancelEditingAlbum;
- (void)cancelEditingAlbumAnimated:(BOOL)animated;

@end

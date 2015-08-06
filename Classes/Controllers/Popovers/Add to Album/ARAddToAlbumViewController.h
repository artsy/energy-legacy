@class ARPopoverController;


@interface ARAddToAlbumViewController : UITableViewController <UITextFieldDelegate>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@property (readwrite, nonatomic, copy) NSArray *artworks;
@property (readwrite, nonatomic, strong) ARPopoverController *container;
@property (readwrite, nonatomic, copy) NSArray *documents;

@property (readonly, nonatomic, copy) NSArray *albums;

@end

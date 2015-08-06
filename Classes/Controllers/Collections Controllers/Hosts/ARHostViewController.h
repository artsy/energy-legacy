#import <MessageUI/MFMailComposeViewController.h>
#import "ARPopoverController.h"
@class ARSelectionHandler;
/// The ARHostViewController is a subclass of the ARBaseViewController
/// whose job is to deal with selection handling within each VC. It does this by forwarding
/// selection state to contained classes, by handling the selection states of the toolbars
/// and by dealing with their related popovers.

/// ARTabbedViewController is the only subclass of ARHostViewController


@interface ARHostViewController : UIViewController <MFMailComposeViewControllerDelegate, WYPopoverControllerDelegate>

/// Init with a model object ( Album / Show / Artist )
- (instancetype)initWithRepresentedObject:(id)object;

/// Artsy model object that the VC represents
@property (strong, nonatomic, readonly) id representedObject;

/// Managed object context for the VC, when nil, uses CoreDataManager mainManagedObjectContext
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) ARSelectionHandler *selectionHandler;

/// Starts selecting for multi-selection
- (void)startSelecting;

/// Saves changes for adding artworks to an album
- (void)commitArtworksToAlbumSelection;
/// cancels changes for adding artworks to an album
- (void)cancelArtworksToAlbumSelection;

/// Finishes multi-selecting and resets the view controller
- (void)endSelecting;

/// Left for subclasses to override
- (void)toggleSelectAllTapped:(id)sender;

/// Left for subclasses to override
- (void)selectAllItems;

/// Left for subclasses to override
- (void)deselectAllItems;

/// Left for subclasses to override
- (BOOL)allItemsAreSelected;

/// Dismiss any popovers controlled by this view controller.
- (void)dismissPopoversAnimated:(BOOL)animate;

/// Switches into the Email selection state;
- (void)emailArtworksTapped:(id)sender;

/// Shows either the mail settings popover or
/// the mail composer
- (void)sendEmailsTapped:(id)sender;

/// Switches to selection mode for adding artworks to Album
- (void)addArtworksToAlbumTapped:(id)sender;

/// Shows the popover for adding artworks to an album
- (void)showAddArtworksToAlbumPopover:(id)sender;

@end

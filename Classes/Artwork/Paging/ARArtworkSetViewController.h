#import <MessageUI/MFMailComposeViewController.h>
#import "ARPopoverController.h"
#import "ARFolioImageMessageViewController.h"

@class Artwork;


@interface ARArtworkSetViewController : UIViewController <UIPageViewControllerDelegate, MFMailComposeViewControllerDelegate, WYPopoverControllerDelegate, ARFolioImageMessageViewControllerDelegate>

- (instancetype)initWithArtworks:(NSFetchedResultsController *)artworks atIndex:(NSInteger)index representedObject:(ARManagedObject *)representedObject withDefaults:(NSUserDefaults *)defaults;

/// An optional context object for the artworks, usually an ARArtworkContainer
@property (nonatomic, strong, readonly) ARManagedObject *representedObject;

@property (nonatomic, assign, readonly) NSInteger index;

@end

#import "ARHostViewController.h"
#import "ARGridViewController+ForSubclasses.h"
#import "ARAlbumViewController.h"
#import "ARSelectionHandler.h"
#import "ARAddToAlbumViewController.h"
#import "NSArray+ObjectsOfClass.h"
#import "ARNavigationController.h"
#import "ARHostSelectionController.h"
#import "ARAlbumEditNavigationController.h"
#import "ARSwitchBoard.h"
#import "AREditAlbumViewController.h"
#import "ARBaseViewController+TransparentModals.h"
#import "ARSelectionToolbarView.h"
#import "ARPopoverController.h"
#import "ARModernEmailArtworksViewController.h"
#import "InstallShotImage.h"
#import "ARTheme.h"


@interface ARHostViewController () <ARModalAlertViewControllerDelegate>
@property (nonatomic, strong) ARHostSelectionController *selectionController;
@property (nonatomic, strong) ARPopoverController *actionsPopoverController;
@end


@implementation ARHostViewController

- (instancetype)initWithRepresentedObject:(id)object
{
    self = [super init];
    if (!self) return nil;

    self.representedObject = object;
    [self setDefaultTitle];

    return self;
}

- (void)setRepresentedObject:(id)representedObject
{
    _representedObject = representedObject;
    [ARSearchViewController sharedController].selectedItem = _representedObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor artsyBackgroundColor];

    _selectionController = [[ARHostSelectionController alloc] initWithHostViewControlller:(id)self];
    [self observeNotification:ARDismissAllPopoversNotification globallyWithSelector:@selector(dismissPopovers)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.selectionController setupDefaultToolbarItems];
}

- (void)setDefaultTitle
{
    if ([_representedObject respondsToSelector:@selector(presentableName)]) {
        self.title = [_representedObject performSelector:@selector(presentableName)];
        return;
    }

    if ([_representedObject respondsToSelector:@selector(title)]) {
        self.title = [_representedObject performSelector:@selector(title)];
        return;
    }

    if ([_representedObject respondsToSelector:@selector(name)]) {
        self.title = [_representedObject performSelector:@selector(name)];
    }
}

#pragma mark -
#pragma mark Handle Selection Callbacks and abstract methods

- (void)toggleSelectAllTapped:(id)sender
{
    if ([self allItemsAreSelected]) {
        [self deselectAllItems];
    } else {
        [self selectAllItems];
    }
}

- (void)selectAllItems
{
    NSLog(@"SelectAllItems should be overrode in %@", self);
}

- (void)deselectAllItems
{
    NSLog(@"DeselectAllItems should be overrode in %@", self);
}

- (BOOL)allItemsAreSelected
{
    NSLog(@"allItemsAreSelected should be overrode in %@", self);
    return NO;
}

- (void)commitArtworksToAlbumSelection
{
    [self.selectionHandler commitSelection];
    [self endSelecting];
}

- (void)cancelArtworksToAlbumSelection
{
    [self.selectionHandler cancelSelection];
    [self endSelecting];
}

- (void)endSelecting
{
    [self.selectionHandler finishSelection];

    [self.selectionController stopListening];
    [self.selectionController endSelectingAnimated:YES];
    [self dismissPopoversAnimated:YES];
}

- (void)startSelecting
{
    [self.selectionController startSelectingAnimated:YES];
    [self.selectionController startListening];
    [self dismissPopoversAnimated:YES];
}

#pragma mark -
#pragma mark Toolbar Actions

- (void)addArtworksToAlbumTapped:(id)sender
{
    [self.selectionHandler startSelectingForAnyAlbum];
    [self startSelecting];
}

- (void)askForNewAlbumName
{
    ARNewAlbumModalViewController *createAlbumVC = [[ARNewAlbumModalViewController alloc] init];
    createAlbumVC.delegate = self;
    [self presentTransparentModalViewController:createAlbumVC animated:YES withAlpha:0.5];
}

- (void)modalViewController:(ARNewAlbumModalViewController *)controller didReturnStatus:(enum ARModalAlertViewControllerStatus)status
{
    [self dismissTransparentModalViewControllerAnimated:YES];
    if (status == ARModalAlertCancel) return;

    Album *album = [Album objectInContext:self.managedObjectContext];
    album.name = controller.inputTextField.text;
    album.createdAt = [NSDate date];

    [[ARSwitchBoard sharedSwitchboard] pushEditAlbumViewController:album animated:YES];
}

- (void)showAddArtworksToAlbumPopover:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];

    NSManagedObjectContext *context = [CoreDataManager mainManagedObjectContext];
    ARAddToAlbumViewController *controller = [[ARAddToAlbumViewController alloc] initWithManagedObjectContext:context];

    NSArray *selectedObjects = [self.selectionHandler.selectedObjects allObjects];
    controller.artworks = [selectedObjects arrayWithOnlyObjectsOfClass:[Artwork class]];
    controller.documents = [selectedObjects arrayWithOnlyObjectsOfClass:[Document class]];

    self.actionsPopoverController = [[ARPopoverController alloc] initWithContentViewController:controller];
    controller.container = self.actionsPopoverController;

    CGRect buttonFrame = [self.view convertRect:sender.frame fromView:sender.superview];
    self.actionsPopoverController.delegate = self;
    sender.selected = YES;

    [self.actionsPopoverController presentPopoverFromRect:buttonFrame
                                                   inView:self.view
                                 permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                                 animated:YES];
}

#pragma mark Emailing Artworks

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    // Fixes a crash in the navbar when leaving the mailVC and reseting the selection mode

    if (![UIDevice isPad] && [viewControllerToPresent isKindOfClass:MFMailComposeViewController.class]) {
        [self.selectionController endSelectingAnimated:YES];
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)emailArtworksTapped:(UIButton *)sender
{
    [self.selectionHandler startSelectingForEmail];
    [self startSelecting];
}

- (void)sendEmailsTapped:(UIButton *)sender
{
    if (self.selectionHandler.selectedObjects.count == 0) {
        return;
    }

    if (![ARModernEmailArtworksViewController canEmailArtworks]) {
        [ARModernEmailArtworksViewController presentNoMailAccountAlert];
        return;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];

    sender.selected = YES;

    NSArray *selectedObjects = [self.selectionHandler.selectedObjects allObjects];
    NSArray *artworks = [selectedObjects arrayWithOnlyObjectsOfClass:Artwork.class];
    NSArray *documents = [selectedObjects arrayWithOnlyObjectsOfClass:Document.class];
    NSArray *images = [selectedObjects arrayWithOnlyObjectsOfClass:InstallShotImage.class];

    ARModernEmailArtworksViewController *emailController = [[ARModernEmailArtworksViewController alloc] initWithArtworks:artworks documents:documents installShots:images context:self.representedObject];
    emailController.hostViewController = self;

    self.actionsPopoverController = [[ARPopoverController alloc] initWithContentViewController:emailController];
    self.actionsPopoverController.delegate = self;

    // Only show the popover if we need to
    if ([emailController hasAdditionalOptions]) {
        CGRect buttonFrame = [self.view convertRect:sender.frame fromView:sender.superview];
        [self.actionsPopoverController presentPopoverFromRect:buttonFrame
                                                       inView:self.view
                                     permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                                     animated:YES];
    } else {
        [emailController emailArtworks];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            [ARAnalytics event:AREmailSentEvent];
            break;
        case MFMailComposeResultCancelled:
            [ARAnalytics event:AREmailCancelledEvent];
            break;
        default:
            ;
    }

    [ARTheme resetWindowTint];
    [self dismissPopoversAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self endSelecting];
}

#pragma mark Popover handling

- (void)dismissPopovers
{
    [self.actionsPopoverController dismissPopoverAnimated:YES];
}

- (BOOL)popoverControllerShouldDismissPopover:(ARPopoverController *)popoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(ARPopoverController *)popoverController
{
    if (popoverController == self.actionsPopoverController) {
        [self.selectionController switchCancelToDone];
    }

    [self.selectionController removeAllButtonHighlights];
}

- (void)dismissPopoversAnimated:(BOOL)animate
{
    [self.actionsPopoverController dismissPopoverAnimated:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if (self.actionsPopoverController.isPopoverVisible) {
        UIButton *doneButton = self.selectionController.doneActionButton.representedButton;
        CGRect buttonFrame = [self.view convertRect:doneButton.frame fromView:[doneButton superview]];
        [self.actionsPopoverController presentPopoverFromRect:buttonFrame inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    }
}

#pragma mark Status Bar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

#pragma mark DI

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

- (ARSelectionHandler *)selectionHandler
{
    return _selectionHandler ?: ARSelectionHandler.sharedHandler;
}

@end

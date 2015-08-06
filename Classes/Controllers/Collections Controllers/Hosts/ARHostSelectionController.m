#import "ARHostSelectionController.h"
#import "ARTabbedViewController.h"
#import "ARSelectionHandler.h"
#import "ARNavigationController.h"
#import "ARSelectionToolbarView.h"
#import <Artsy+UILabels/ARLabelSubclasses.h>
#import "ARAlbumViewController.h"


@interface ARHostSelectionController ()

@property (readonly, nonatomic, assign) BOOL isSelecting;
@property (nonatomic, strong) UIBarButtonItem *addToAlbumsButton;
@property (nonatomic, strong) UIBarButtonItem *mailButton;
@property (nonatomic, strong) UIBarButtonItem *selectAllButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;

@property (nonatomic, strong) ARSelectionHandler *selectionHandler;
@end


@implementation ARHostSelectionController

- (instancetype)initWithHostViewControlller:(ARTabbedViewController *)hostViewController
{
    self = [super init];
    if (!self) return nil;

    _hostVC = hostViewController;
    _selectionHandler = hostViewController.selectionHandler;

    return self;
}

- (ARNavigationController *)navigationController
{
    return (id)self.hostVC.navigationController;
}

- (void)startListening
{
    [self observeNotification:ARGridSelectionChangedNotification onObject:self.selectionHandler withSelector:@selector(selectionStateChanged)];
}

- (void)stopListening
{
    [self stopObservingNotification:ARGridSelectionChangedNotification onObject:self.selectionHandler];
}

- (void)startSelectingAnimated:(BOOL)animated
{
    [self clearToolbarButtons];
    self.navItem.hidesBackButton = YES;

    _isSelecting = YES;

    [self.hostVC showTopButtonToolbar:YES animated:animated];
    [self.hostVC showBottomButtonToolbar:YES animated:animated];

    [self addEditSelectionControls];
    [self selectionStateChanged];
}

- (void)endSelectingAnimated:(BOOL)animated
{
    [self.hostVC showTopButtonToolbar:NO animated:animated];
    [self.hostVC showBottomButtonToolbar:NO animated:animated];

    _isSelecting = NO;
    self.navItem.titleView = nil;
    self.navItem.hidesBackButton = NO;
    [self clearToolbarButtons];

    [self setupDefaultToolbarItems];
}

- (void)clearToolbarButtons
{
    self.navItem.leftBarButtonItem = nil;
    self.navItem.rightBarButtonItem = nil;

    self.navItem.leftBarButtonItems = nil;
    self.navItem.rightBarButtonItems = nil;
}

- (UINavigationItem *)navItem
{
    return self.hostVC.navigationItem;
}

- (void)switchCancelToDone
{
    NSString *doneString = [NSLocalizedString(@"Done", @"Done Button Prompt") uppercaseString];
    [self.cancelButton.representedButton setTitle:doneString forState:UIControlStateNormal];
}

- (void)removeAllButtonHighlights
{
    self.doneActionButton.representedButton.selected = NO;
}

- (void)setupDefaultToolbarItems
{
    NSString *addToCollectionString = NSLocalizedString(@"Add To Album", @"Add To Album Button Text");
    NSString *messagesString = NSLocalizedString(@"Messages", @"Messages Button Text");

    self.addToAlbumsButton = [UIBarButtonItem toolbarImageButtonWithName:addToCollectionString withTarget:self.hostVC andSelector:@selector(addArtworksToAlbumTapped:)];
    self.mailButton = [UIBarButtonItem toolbarImageButtonWithName:messagesString withTarget:self.hostVC andSelector:@selector(emailArtworksTapped:)];

    UIBarButtonItem *editItem = [UIBarButtonItem toolbarButtonWithTitle:@"Edit" target:self.hostVC action:@selector(toggleSelectMode)];

    UIBarButtonItem *search = self.navigationController.newSearchPopoverButton;
    if (self.addEditButton) {
        self.navItem.rightBarButtonItems = @[ search, self.mailButton, self.addToAlbumsButton, editItem ];
    } else {
        self.navItem.rightBarButtonItems = @[ search, self.mailButton, self.addToAlbumsButton ];
    }
}

- (void)addEditSelectionControls
{
    NSString *cancelString = [NSLocalizedString(@"Cancel", @"Cancel Selection Button Text") uppercaseString];
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelString style:UIBarButtonItemStylePlain target:self.hostVC action:@selector(endSelecting)];

    NSString *selectAllString = [NSLocalizedString(@"Select All", @"Select All Button Text") uppercaseString];
    self.selectAllButton = [[UIBarButtonItem alloc] initWithTitle:selectAllString style:UIBarButtonItemStylePlain target:self.hostVC action:@selector(toggleSelectAllTapped:)];

    NSString *completedActionString = nil;
    SEL callback = nil;

    if (self.selectionHandler.isSelectingForEmail) {
        completedActionString = [NSLocalizedString(@"Compose", @"Compose Button Text") uppercaseString];
        callback = @selector(sendEmailsTapped:);
    } else {
        completedActionString = [NSLocalizedString(@"Add", @"'Add' button (for Album) text") uppercaseString];
        callback = @selector(showAddArtworksToAlbumPopover:);
    }

    _doneActionButton = [[UIBarButtonItem alloc] initWithTitle:completedActionString style:UIBarButtonItemStylePlain target:self.hostVC action:callback];

    [self.hostVC.bottomToolbar setBarButtonItems:@[ self.cancelButton ]];
    [self.hostVC.topToolbar setBarButtonItems:@[ self.selectAllButton, self.doneActionButton ]];

    [self selectionStateChanged];
}

- (void)selectionStateChanged
{
    NSSet *selectedObjects = self.selectionHandler.selectedObjects;
    UIButton *selectAllButton = self.selectAllButton.representedButton;
    NSString *selectAllText = nil;

    self.doneActionButton.enabled = (selectedObjects.count > 0);

    if ([self.hostVC allItemsAreSelected]) {
        selectAllText = [NSLocalizedString(@"Deselect All", @"Deselect All Button Text") uppercaseString];

    } else {
        selectAllText = [NSLocalizedString(@"Select All", @"Select All Button Text") uppercaseString];
    }

    [selectAllButton setTitle:selectAllText forState:UIControlStateNormal];
    [selectAllButton sizeToFit];
    [self updateTitleWithCount:selectedObjects.count];
}

- (void)updateTitleWithCount:(NSInteger)count
{
    NSString *title = nil;

    if (count == 0) {
        NSString *type = self.selectionHandler.isSelectingForEmail ? @"Email" : @"Album";
        title = NSLocalizedString([@"Select Items to " stringByAppendingString:type], @"Select Items Email Title Prompt");

    } else {
        NSString *items = (count == 1) ? @"Item" : @"Items";
        NSString *itemsSelectedFormatString = NSLocalizedString(@"%@ %@ Selected", @"%@ Items Selected Title Prompt");
        title = [NSString stringWithFormat:itemsSelectedFormatString, @(count), items];
    }

    ARSansSerifLabel *titleLabel = [[ARSansSerifLabel alloc] init];
    titleLabel.text = title;
    CGFloat fontSize = [UIDevice isPad] ? ARFontSansLarge : ARPhoneFontSansRegular;
    titleLabel.font = [UIFont sansSerifFontWithSize:fontSize];
    titleLabel.textColor = [UIColor artsyForegroundColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    self.navItem.titleView = titleLabel;
}

- (ARSelectionHandler *)selectionHandler
{
    return _selectionHandler ?: [ARSelectionHandler sharedHandler];
}

@end

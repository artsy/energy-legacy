#import "ARGridView+CoverHandling.h"
#import "ARButtonPopoverViewController.h"
#import "ARMultipleButtonsPopoverViewController.h"
#import "ARSelectionHandler.h"
#import "ARGridViewCell.h"
#import "ARArtworkContainerViewController.h"
#import "ARGridViewDataSource.h"
#import "ARPopoverController.h"


@interface ARGridViewCell (Private)
- (CGRect)imageFrame;
@end


@interface ARGridView ()
{
    ARPopoverController *_coverPopoverController;
    UICollectionView *_gridView;

    UILongPressGestureRecognizer *_longPress;
    NSIndexPath *_indexPathForPopover;
}

@property (nonatomic, strong) ARGridViewDataSource *dataSource;
@end


@implementation ARGridView (CoverHandling)

#pragma mark -
#pragma mark Changing Cover Management

- (void)longPressed:(UILongPressGestureRecognizer *)recognizer
{
    BOOL isSelectingArtworks = self.selectionHandler.isSelecting;
    BOOL canHaveCover = [self.delegate isKindOfClass:[ARArtworkContainerViewController class]];
    BOOL isShow = [self.delegate isHostingShow];
    BOOL isLocation = [self.delegate isHostingLocation];

    if (!canHaveCover || isShow || isLocation || isSelectingArtworks) return;

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:_gridView];
        _indexPathForPopover = [_gridView indexPathForItemAtPoint:touchLocation];
        if (_indexPathForPopover.row == NSNotFound) return;

        // Loop through all artworks and dim them to highlight
        // the found cell for a long selection

        ARGridViewCell __block *cell;
        [UIView animateWithDuration:ARAnimationDuration animations:^{
            for (ARGridViewCell *visibleCell in [_gridView visibleCells]) {
                if (visibleCell.indexPath.row != _indexPathForPopover.row) {
                    visibleCell.alpha = 0.5;
                } else {
                    cell = visibleCell;
                }
            }
        }];

        if (cell) {
            [self presentCoverPopoverForCell:cell];
        }
    }
}

- (void)presentCoverPopoverForCell:(ARGridViewCell *)cell
{
    CGRect popupOriginRect = [self popoverRectForCell:cell];
    WYPopoverArrowDirection direction = [self shouldPresentPopoverFromLeft] ? WYPopoverArrowDirectionRight : WYPopoverArrowDirectionLeft;

    _coverPopoverController = [self newPopoverControllerForDelegate:self.delegate];
    [_coverPopoverController presentPopoverFromRect:popupOriginRect inView:_gridView.superview
                           permittedArrowDirections:direction
                                           animated:YES];
}

- (BOOL)shouldPresentPopoverFromLeft
{
    UIView *cell = [_gridView cellForItemAtIndexPath:_indexPathForPopover];
    CGRect gridViewRect = [self.superview convertRect:cell.frame fromView:_gridView];
    return (gridViewRect.origin.x > (CGRectGetWidth(self.bounds) / 2 - 20));
}

- (CGRect)popoverRectForCell:(ARGridViewCell *)cell
{
    CGRect imageRect = [cell imageFrame];
    CGRect gridViewRect = [self.superview convertRect:cell.frame fromView:_gridView];

    // We want to present the cover from the edge of the image, not the grid cell

    CGFloat delta = gridViewRect.size.width - imageRect.size.width;
    gridViewRect.size.width = imageRect.size.width;
    gridViewRect.origin.x += delta / 2;

    // We need to determine which side to present the popover from, as it should always point towards the
    // direction with the furthest distance to the window's frame.

    CGFloat PopoverMargin = 12;
    BOOL useLeftEdge = [self shouldPresentPopoverFromLeft];
    CGFloat xPosition = useLeftEdge ? gridViewRect.origin.x + PopoverMargin : gridViewRect.origin.x + gridViewRect.size.width - PopoverMargin;
    return CGRectMake(xPosition, gridViewRect.origin.y + (gridViewRect.size.height / 2), 1, 1);
}

- (ARPopoverController *)newPopoverControllerForDelegate:(id<ARGridViewDelegate>)delegate
{
    NSArray *buttons = [self popoverButtonsForDelegate:delegate];
    UIViewController *popoverViewController = [self contentViewControllerWithButtons:buttons delegate:delegate];

    ARPopoverController *popoverController = [[ARPopoverController alloc] initWithContentViewController:popoverViewController];
    popoverController.delegate = self;
    popoverController.passthroughViews = buttons;

    return popoverController;
}

- (NSArray *)popoverButtonsForDelegate:(id<ARGridViewDelegate>)delegate
{
    NSMutableArray *buttons = [[NSMutableArray alloc] init];

    CGFloat buttonWidth = [UIDevice isPad] ? 220 : 120;
    ARFlatButton *setAsACoverButton = [[ARFlatButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 44)];
    [setAsACoverButton setTitle:NSLocalizedString(@"Set as cover", @"Set as cover button title") forState:UIControlStateNormal];
    [setAsACoverButton addTarget:self action:@selector(setCoverAndDismissPopover:) forControlEvents:UIControlEventTouchUpInside];

    if ([delegate isHostingEditableAlbum]) {
        ARFlatButton *removeFromAlbumButton = [[ARFlatButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 44)];
        [removeFromAlbumButton setTitle:NSLocalizedString(@"Remove from Album", @"Remove from Album title") forState:UIControlStateNormal];
        [removeFromAlbumButton addTarget:self action:@selector(didPressRemoveFromAlbum:) forControlEvents:UIControlEventTouchUpInside];

        [buttons addObject:setAsACoverButton];
        [buttons addObject:removeFromAlbumButton];
    } else if ([self.delegate isHostingShow] || [self.delegate isHostingLocation]) {
    } else {
        [buttons addObject:setAsACoverButton];
    }

    return buttons;
}

- (UIViewController *)contentViewControllerWithButtons:(NSArray *)buttons delegate:(id<ARGridViewDelegate>)delegate
{
    UIViewController *popoverViewController = nil;

    if ([delegate isHostingEditableAlbum]) {
        popoverViewController = [[ARMultipleButtonsPopoverViewController alloc] initWithButtons:buttons];
    } else {
        popoverViewController = [[ARButtonPopoverViewController alloc] initWithButton:buttons[0] andStyle:ARButtonPopoverDefault];
    }

    return popoverViewController;
}

- (void)didPressRemoveFromAlbum:(ARFlatButton *)sender
{
    id<ARGridViewItem> item = [self.dataSource objectAtIndexPath:_indexPathForPopover];

    __weak __typeof(self) weakSelf = self;
    NSMutableArray *cells = [NSMutableArray array];
    ARGridViewCell *cellToRemove = nil;

    for (ARGridViewCell *cell in [_gridView visibleCells]) {
        if (cell.indexPath.row == _indexPathForPopover.row) {
            cellToRemove = cell;
        } else {
            [cells addObject:cell];
        }
    }
    [_coverPopoverController dismissPopoverAnimated:YES];

    /*
     TIMELINE
     Shrink cell ------------|Remove cell
     |---------|Fade grid out|Fade grid in---|

     */

    [UIView animateWithDuration:ARAnimationDuration animations:^{
        cellToRemove.transform = CGAffineTransformMakeScale(0.0001, 0.0001);

    } completion:^(BOOL finished) {
        [weakSelf.delegate removeArtworkFromAlbum:item completion:NULL];
        cellToRemove.transform = CGAffineTransformIdentity;
    }];

    [UIView animateWithDuration:ARAnimationDuration * .33 delay:ARAnimationDuration * .66 options:0 animations:^{
        _gridView.alpha = 0;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:ARAnimationDuration animations:^{
            _gridView.alpha = 1;
        }];
    }];
}

- (void)setCoverAndDismissPopover:(ARFlatButton *)sender
{
    [sender setBackgroundColor:[UIColor artsyPurpleRegular] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    // Pass the message back up to the Grid View Controller

    Artwork<ARGridViewItem> *artwork = (id)[self.dataSource objectAtIndexPath:_indexPathForPopover];
    [self.delegate setCover:artwork.mainImage];

    SEL dismiss = NSSelectorFromString(@"dismissCoverPopover");
    [self performSelector:dismiss withObject:nil afterDelay:0.25];
}

@end

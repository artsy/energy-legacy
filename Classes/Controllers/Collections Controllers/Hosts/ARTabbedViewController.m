@import Artsy_UIFonts;

#import "ARTabbedViewController.h"
#import "ARSelectionHandler.h"
#import "ARSortViewController.h"
#import "ARSortCache.h"
#import "ARBottomAlignedToolbar.h"
#import "ARTabbedViewControllerDataSource.h"
#import <ORStackView/ORStackView.h>
#import "ARSelectionToolbarView.h"
#import "ARSortDefinition.h"

#define SORT_BUTTON_WIDTH 220
//not the best name -- we're just trying to keep it out of the way of the top + bottom borders
#define SORT_BUTTON_MARGIN 2
#define SORT_POPOVER_OFFSET 16
#define SORT_BUTTON_ARROW_WIDTH 12
#define SORT_BUTTON_ARROW_FONT_SIZE 10
#define SORT_BUTTON_ARROW_TOP_INSET 4
#define SORT_BUTTON_OUTERHEIGHT 46


@interface ARTabbedViewController ()
@property (readonly, nonatomic, strong) ORStackView *stackView;

@property (readonly, nonatomic, strong) NSLayoutConstraint *switchHeightContraint;
@property (readonly, nonatomic, strong) ARTabbedViewControllerDataSource *tabsDataSource;
@property (readonly, nonatomic, weak) ORStackView *headerStackView;

@property (readonly, nonatomic, strong) ARTabContentView *tabView;

@property (readonly, nonatomic, assign) CGFloat maxHeaderHeight;
@property (readonly, nonatomic, assign) CGFloat headerHeight;
@property (readonly, nonatomic, weak) UILabel *titleLabel;

@property (readonly, nonatomic, strong) NSLayoutConstraint *bottomToolbarHeightConstraint;
@property (readonly, nonatomic, strong) NSLayoutConstraint *topToolbarHeightConstraint;

@end


@implementation ARTabbedViewController {
    ARPopoverController *_sortPopoverVC;
    UIButton *_sortButton;
    enum ARArtworkSortOrder _sortIndex;
    NSArray *_sorts;
}

- (void)viewDidLoad
{
    // To give DI a chance
    _tabsDataSource = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:self.representedObject managedObjectContext:self.managedObjectContext selectionHandler:self.selectionHandler];

    [super viewDidLoad];

    _stackView = [[ORStackView alloc] initWithFrame:self.parentViewController.view.bounds];
    _stackView.bottomMarginHeight = 0;
    [self.view addSubview:self.stackView];
    [_stackView alignToView:self.view];


    _topToolbar = [self createToolbar];
    _topToolbar.attatchedToTop = YES;

    _topToolbarHeightConstraint = [[_topToolbar constrainHeight:@"0"] firstObject];
    [_stackView addSubview:_topToolbar withTopMargin:@"0" sideMargin:@"0"];

    ORStackView *header = [[ORStackView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 1)];
    header.bottomMarginHeight = 0;
    _headerStackView = header;
    [_stackView addSubview:header withTopMargin:@"0" sideMargin:@"0"];

    if (![UIDevice isPad]) {
        ARFolioSansSerifLabel *label = [[ARFolioSansSerifLabel alloc] init];
        label.font = [UIFont sansSerifFontWithSize:ARPhoneFontSansLarge];

        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        label.text = self.title;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;

        [self.headerStackView addSubview:label withTopMargin:@"6" sideMargin:@"0"];
    } else {
        [self setPadTitle:self.title];
    }

    // Add switch view at the top
    _switchView = [self createSwitchView];
    [_headerStackView addSubview:self.switchView withTopMargin:@"0" sideMargin:@"0"];

    // Add an TabView underneath, that takes up available space
    _tabView = [self createTabView];
    [self.tabView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];

    [_stackView addSubview:self.tabView withTopMargin:@"10" sideMargin:@"0"];

    [self.headerStackView layoutIfNeeded];
    _maxHeaderHeight = CGRectGetHeight(self.headerStackView.frame);
    _headerHeight = self.maxHeaderHeight;
    _switchHeightContraint = [[self.headerStackView constrainHeight:@(self.maxHeaderHeight).stringValue] firstObject];

    _bottomToolbar = [self createToolbar];
    _bottomToolbar.attatchedToBottom = YES;
    _bottomToolbarHeightConstraint = [[_bottomToolbar constrainHeight:@"0"] firstObject];
    [_stackView addSubview:_bottomToolbar withTopMargin:@"0" sideMargin:@"0"];

    [self.tabView setCurrentViewIndex:0 animated:NO];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];

    if (![UIDevice isPad]) {
        self.navigationItem.title = @"";
        self.titleLabel.text = title;
    }
}

- (void)setPadTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.textColor = [UIColor artsyForegroundColor];
    titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansLarge];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = title.uppercaseString;

    self.navigationItem.titleView = titleLabel;
}

#pragma mark - Selection Handling

- (void)startSelecting
{
    [super startSelecting];

    if (self.switchView.rightSupplementaryView) {
        [UIView animateWithDuration:ARAnimationQuickDuration animations:^{
            self.switchView.rightSupplementaryView.alpha = 0;
        }];
    }
    [[self currentChildController] setIsSelectable:YES animated:YES];
}

- (void)endSelecting
{
    [super endSelecting];

    if (self.switchView.rightSupplementaryView) {
        [UIView animateWithDuration:ARAnimationQuickDuration animations:^{
            self.switchView.rightSupplementaryView.alpha = 1;
        }];
    }

    [[self currentChildController] setIsSelectable:NO animated:YES];
}

- (void)selectAllItems
{
    [[self currentChildController] selectAllItems];
}

- (void)deselectAllItems
{
    [[self currentChildController] deselectAllItems];
}

- (BOOL)allItemsAreSelected
{
    return [[self currentChildController] allItemsAreSelected];
}

- (ARGridViewController *)currentChildController
{
    return (ARGridViewController *)[self.tabView currentViewController];
}

- (void)showBottomToolbar:(BOOL)showToolbar animated:(BOOL)animated
{
    BOOL hasToolbar = self.bottomToolbarHeightConstraint.constant != 0;
    if (showToolbar == hasToolbar) return;

    [self.navigationController setNavigationBarHidden:showToolbar animated:animated];

    [UIView animateIf:animated duration:ARAnimationQuickDuration:^{
        self.bottomToolbarHeightConstraint.constant = showToolbar ? 56 : 0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}


#pragma mark -
#pragma mark Create our Views

- (ARTabContentView *)createTabView
{
    ARTabContentView *tabView = [[ARTabContentView alloc] initWithFrame:self.view.bounds hostViewController:self delegate:self dataSource:self.tabsDataSource];
    tabView.switchView = self.switchView;
    return tabView;
}

- (ARSecondarySwitchView *)createSwitchView
{
    ARSecondarySwitchView *switchView = [[ARSecondarySwitchView alloc] initWithFrame:CGRectZero];
    switchView.titles = self.tabsDataSource.potentialTitles;

    if ([self.representedObject conformsToProtocol:@protocol(ARArtworkContainer)]) {
        id<ARArtworkContainer> container = (id<ARArtworkContainer>)self.representedObject;

        if ([UIDevice isPad] && [container collectionSize] > 1 && !self.selectionHandler.isSelecting) {
            _sorts = [container availableSorts];
            switchView.rightSupplementaryView = [self sortButton];
        }
    }

    return switchView;
}

- (UIView *)sortButton
{
    if (_sorts.count == 0) return nil;

    _sortButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SORT_BUTTON_WIDTH, _switchView.intrinsicContentSize.height - SORT_BUTTON_MARGIN)];

    _sortIndex = [ARSortCache sortOrderForObjectWithSlug:[(id<ARArtworkContainer>)self.representedObject slug]];
    if (_sortIndex == ARArtworksSortOrderNotFound) {
        _sortIndex = [_sorts[0] order];
    }

    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(SORT_BUTTON_WIDTH - SORT_BUTTON_ARROW_WIDTH,
                                                               SORT_BUTTON_ARROW_TOP_INSET,
                                                               SORT_BUTTON_ARROW_WIDTH,
                                                               SORT_BUTTON_OUTERHEIGHT - SORT_BUTTON_ARROW_TOP_INSET)];

    arrow.font = [UIFont serifFontWithSize:SORT_BUTTON_ARROW_FONT_SIZE];
    arrow.text = @"▼";
    arrow.backgroundColor = [UIColor artsyBackgroundColor];
    arrow.textColor = [UIColor artsyForegroundColor];

    [_sortButton insertSubview:arrow belowSubview:_sortButton.titleLabel];
    _sortButton.backgroundColor = [UIColor artsyBackgroundColor];
    _sortButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _sortButton.titleLabel.font = [UIFont serifFontWithSize:ARFontSerifSmall];
    _sortButton.contentEdgeInsets = UIEdgeInsetsMake(SORT_BUTTON_ARROW_TOP_INSET, 0, 0, SORT_BUTTON_ARROW_WIDTH + 3);

    ARSortDefinition *definition = [_sorts find:^BOOL(ARSortDefinition *sort) {
        return sort.order == _sortIndex;
    }];

    NSString *name = definition.name;
    if (!name) {
        name = [_sorts.firstObject name];
        _sortIndex = [_sorts.firstObject order];
    }

    NSString *localizedSortFormat = NSLocalizedString(@"By %@ ", @"Sorted by button text");
    NSString *title = [[NSString stringWithFormat:localizedSortFormat, name] uppercaseString];
    [_sortButton setTitle:title forState:UIControlStateNormal];
    [_sortButton setTitleColor:[UIColor artsyForegroundColor] forState:UIControlStateNormal];
    [_sortButton addTarget:self action:@selector(sortButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    return _sortButton;
}

- (void)sortButtonPressed:(UIButton *)sender
{
    CGRect source = sender.frame;
    source.origin.x += source.size.width - SORT_POPOVER_OFFSET;
    source.size.width = 1;

    ARSortViewController *sortVC = [[ARSortViewController alloc] initWithSorts:_sorts andSelectedIndex:_sortIndex];
    _sortPopoverVC = [[ARPopoverController alloc] initWithContentViewController:sortVC];
    sortVC.delegate = self;

    [_sortPopoverVC presentPopoverFromRect:source inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

- (void)newSortWasSelected:(ARSortDefinition *)sort;
{
    [_sortPopoverVC dismissPopoverAnimated:YES];
    _sortIndex = sort.order;

    id<ARArtworkContainer> container = self.representedObject;
    NSString *slug = [container slug];

    [ARSortCache setOrder:_sortIndex forObjectWithSlug:slug];
    [UIView transitionWithView:_sortButton duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        NSString *newTitle = [[NSString stringWithFormat:@"By %@", sort.name] uppercaseString];
        [_sortButton setTitle:newTitle forState:UIControlStateNormal];

    } completion:nil];

    NSFetchRequest *newResults = [container artworksFetchRequestSortedBy:sort.order];
    [[self currentChildController] setResults:newResults animated:YES];
}

- (void)gridViewController:(ARGridViewController *)gridViewController didHaveGridScroll:(ARGridView *)gridView
{
    CGFloat yOffset = gridView.contentOffset.y;
    CGFloat potentialOffset = self.headerHeight - yOffset;
    CGFloat oldOffset = self.headerHeight;

    _headerHeight = MAX(MIN(potentialOffset, self.maxHeaderHeight), 0);

    if (self.headerHeight != oldOffset) {
        gridView.contentOffset = CGPointMake(gridView.contentOffset.x, 0);
        _switchView.alpha = self.headerHeight / self.maxHeaderHeight;
        _switchHeightContraint.constant = self.headerHeight;
    }
}

#pragma mark - Tab view delegate

- (void)tabView:(ARTabContentView *)tabView didChangeSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    self.currentChildController.gridViewScrollDelegate = self;

    if (index != 0) {
        [_sortPopoverVC dismissPopoverAnimated:NO];
        [UIView animateIf:animated duration:ARAnimationQuickDuration:^{
            _sortButton.alpha = 0;
        }];

    } else if (_sortButton != nil) {
        [UIView animateIf:animated duration:ARAnimationQuickDuration:^{
            _sortButton.alpha = 1;
        }];
    }
}

#pragma mark - Top / Bottom buttons

- (void)showTopButtonToolbar:(BOOL)show animated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:show animated:YES];
    [UIView animateIf:animated duration:ARAnimationDuration:^{
        self.topToolbar.alpha = show ? 1 : 0;
        self.topToolbarHeightConstraint.constant = show ? self.topToolbar.intrinsicContentSize.height : 0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)showBottomButtonToolbar:(BOOL)show animated:(BOOL)animated
{
    [UIView animateIf:animated duration:ARAnimationDuration:^{
        self.topToolbar.alpha = show;
        self.bottomToolbarHeightConstraint.constant = show ? self.bottomToolbar.intrinsicContentSize.height : 0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (ARSelectionToolbarView *)createToolbar
{
    ARSelectionToolbarView *bottomToolbar = [[ARSelectionToolbarView alloc] initWithFrame:CGRectZero];
    bottomToolbar.horizontallyConstrained = ![UIDevice isPad];
    bottomToolbar.backgroundColor = [UIColor artsyBackgroundColor];
    return bottomToolbar;
}

@end

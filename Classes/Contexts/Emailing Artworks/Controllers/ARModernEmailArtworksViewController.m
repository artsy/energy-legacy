#import "ARModernEmailArtworksViewController.h"
#import "ARModernEmailArtworksViewControllerDataSource.h"
#import "ARGroupedTableViewCell.h"
#import "ARTableHeaderView.h"
#import "ARThumbnailImageSelectionView.h"
#import "AREmailSettings.h"
#import "ARFlatButton.h"
#import "Document.h"
#import "AREmailComposer.h"
#import "ARPopoverSegmentControl.h"


@interface NSObject (HostVC)
- (void)dismissPopoversAnimated:(BOOL)animate;
@end


@interface ARModernEmailArtworksViewController ()
@property (readonly, strong, nonatomic) ARModernEmailArtworksViewControllerDataSource *artworkDataSource;
@property (readwrite, strong, nonatomic) ARThumbnailImageSelectionView *additionalImagesSelectionView;
@property (readwrite, strong, nonatomic) ARThumbnailImageSelectionView *installationShotsSelectionView;

@property (readonly, copy, nonatomic) NSArray *artworks;
@property (readonly, copy, nonatomic) NSArray *documents;
@property (readonly, copy, nonatomic) NSArray *installShots;

@property (readonly, strong, nonatomic) ARManagedObject *context;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

static NSString *ARDefaultTickIdentifier = @"ARDefaultTickIdentifier";
static NSString *ARHeaderIdentifier = @"ARHeaderIdentifier";
static NSString *ARAdditionalImagesRowIdentifier = @"ARAdditionalImagesRowIdentifier";
static NSString *ARInstallationShotRowIdentifier = @"ARInstallationShotRowIdentifier";
static NSString *ARPricesRowIdentifier = @"ARPricesRowIdentifier";


@implementation ARModernEmailArtworksViewController

- (instancetype)initWithArtworks:(NSArray *)artworks documents:(NSArray *)documents installShots:(NSArray *)installShots context:(ARManagedObject *)context
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;

    _artworks = artworks.copy;
    _documents = documents.copy;
    _installShots = installShots.copy;
    _context = context;

    _artworkDataSource = [[ARModernEmailArtworksViewControllerDataSource alloc] init];

    return self;
}

- (void)setupDefaults
{
    // As NSUserDefaults are used for storing state inside here ( this is useful for persistence )
    // we need to ensure any selected items are already selected.

    for (Document *document in self.documents) {
        NSString *defaultKey = [self defaultKeyForDocumentIdentifier:document.slug];
        [self.userDefaults setBool:YES forKey:defaultKey];
    }

    for (Image *image in self.installShots) {
        NSString *defaultKey = [self defaultKeyForIdentifier:image.slug];
        [self.userDefaults setBool:YES forKey:defaultKey];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupDefaults];

    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.tableView alignTop:@"10" leading:@"10" bottom:@"-60" trailing:@"-10" toView:self.view];

    [self.tableView registerClass:ARGroupedTableViewCell.class forCellReuseIdentifier:ARDefaultTickIdentifier];
    [self.tableView registerClass:ARGroupedTableViewCell.class forCellReuseIdentifier:ARInstallationShotRowIdentifier];
    [self.tableView registerClass:ARGroupedTableViewCell.class forCellReuseIdentifier:ARAdditionalImagesRowIdentifier];
    [self.tableView registerClass:ARGroupedTableViewCell.class forCellReuseIdentifier:ARPricesRowIdentifier];


    ARTableViewData *tableViewData = [[ARTableViewData alloc] init];
    NSArray *artworks = self.artworks;

    if ([self.artworkDataSource shouldShowArtworkInfoSection:artworks]) {
        [tableViewData addSectionData:[self sectionDataForArtworkInfo:artworks]];
    }

    if ([self.artworkDataSource artworksShouldShowPrice:artworks] || [self.artworkDataSource artworksShouldShowBackendPrice:artworks]) {
        [tableViewData addSectionData:[self sectionDataForPrices:artworks]];
    }

    if ([self.artworkDataSource artworksShouldShowAdditionalImages:artworks]) {
        [tableViewData addSectionData:[self sectionDataForArtworkAdditionalImages:artworks]];
    }

    if ([self.artworkDataSource artworksShouldShowInstallShots:artworks context:self.context]) {
        [tableViewData addSectionData:[self sectionDataForShowInstallShots:artworks]];
    }

    NSArray *documentContainers = [self.artworkDataSource sortedArrayOfRelatedShowDocumentContainersForArtworks:artworks documents:self.documents];
    for (NSObject<ARDocumentContainer> *container in documentContainers) {
        [tableViewData addSectionData:[self sectionDataForDocumentContainer:container]];
    }

    ARSectionData *lastSection = tableViewData.allSections.lastObject;
    lastSection.footerHeight = 1; // 0 doesnt work.

    self.tableViewData = tableViewData;

    UIView *emailButton = [self sendEmailButton];
    [self.view addSubview:emailButton];
    [emailButton alignTop:nil leading:@"10" bottom:@"-10" trailing:@"-10" toView:self.view];
    [emailButton constrainHeight:@"40"];
}

- (ARSectionData *)sectionDataForArtworkInfo:(NSArray *)artworks
{
    ARSectionData *sectionData = [[ARSectionData alloc] init];

    NSString *title = NSLocalizedString(@"Include Artwork Info", @"Emailing Artwork Popover title for additional info");
    sectionData.headerView = [self headerViewForTitle:title];

    if ([self.artworkDataSource artworksShouldShowSupplementaryInfo:artworks]) {
        NSString *title = NSLocalizedString(@"Supplementary Information", @"Emailing Artwork Popover toggle for Artwork Info");
        NSString *defaultKey = [self defaultKeyForIdentifier:@"Supplementary Information"];
        [sectionData addCellData:[self cellDataForTappableRowTitled:title defaultKey:defaultKey]];
    }

    if ([self.artworkDataSource artworksShouldShowInventoryID:artworks]) {
        NSString *title = NSLocalizedString(@"Inventory ID", @"Emailing Artwork Popover toggle for Inventory ID");
        NSString *defaultKey = [self defaultKeyForIdentifier:@"Inventory ID"];
        [sectionData addCellData:[self cellDataForTappableRowTitled:title defaultKey:defaultKey]];
    }

    return sectionData;
}

- (ARSectionData *)sectionDataForPrices:(NSArray *)artworks
{
    ARSectionData *sectionData = [[ARSectionData alloc] init];

    NSString *title = NSLocalizedString(@"Include Artwork Prices", @"Emailing Artwork Popover title for Artwork Prices");
    sectionData.headerView = [self headerViewForTitle:title];

    NSString *noPricesString = NSLocalizedString(@"No Prices", @"Emailing Artwork No Artwork Prices Option");
    NSString *rangedPricesString = NSLocalizedString(@"Public Price", @"Emailing Artwork Prices Ranges Option");
    NSString *exactPricesString = NSLocalizedString(@"Backend Price", @"Emailing Artwork Exact Prices Option");

    BOOL showPublicPrice = [self.artworkDataSource artworksShouldShowPrice:artworks];
    BOOL showExactPrices = [self.artworkDataSource artworksShouldShowBackendPrice:artworks];

    NSMutableArray *titles = [NSMutableArray arrayWithObject:noPricesString];
    if (showPublicPrice) {
        [titles addObject:rangedPricesString];
    }
    if (showExactPrices) {
        [titles addObject:exactPricesString];
    }

    ARCellData *cellData = [[ARCellData alloc] initWithIdentifier:ARPricesRowIdentifier];
    cellData.cellConfigurationBlock = ^(ARGroupedTableViewCell *cell) {
        cell.accessoryView = nil;
        cell.isTopCell = YES;

        ARPopoverSegmentControl *segment = [[ARPopoverSegmentControl alloc] initWithItems:titles];
        [segment addTarget:self action:@selector(selectedNewPriceIndex:) forControlEvents:UIControlEventValueChanged];

        NSInteger defaultIndex = [self.userDefaults integerForKey:[self defaultKeyForIdentifier:@"Price Type"]];
        segment.selectedSegmentIndex = MIN(segment.numberOfSegments, defaultIndex);

        // Contain it within another view to hide the outer border
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 300, 40)];
        container.clipsToBounds = YES;
        [cell.contentView addSubview:container];
        [container alignTop:@"4" leading:@"4" bottom:@"-4" trailing:@"-4" toView:cell.contentView];

        [container addSubview:segment];
        [segment alignTop:@"-2" leading:@"-2" bottom:@"2" trailing:@"2" toView:cell.contentView];
    };

    [sectionData addCellData:cellData];

    return sectionData;
}

- (void)selectedNewPriceIndex:(ARPopoverSegmentControl *)control
{
    [self.userDefaults setInteger:control.selectedSegmentIndex forKey:[self defaultKeyForIdentifier:@"Price Type"]];
}

- (ARSectionData *)sectionDataForDocumentContainer:(NSObject<ARDocumentContainer> *)container
{
    ARSectionData *sectionData = [[ARSectionData alloc] init];
    NSString *localFormat = NSLocalizedString(@"Include %@'s Docs", @"Emailing Artwork Popover title for a document container (artist/show)");
    sectionData.headerView = [self headerViewForTitle:[NSString stringWithFormat:localFormat, container.name]];

    for (Document *document in [container sortedDocuments]) {
        NSString *defaultKey = [self defaultKeyForDocumentIdentifier:document.slug];
        ARCellData *data = [self cellDataForTappableRowTitled:document.title defaultKey:defaultKey];
        [sectionData addCellData:data];
    }

    return sectionData;
}

- (ARSectionData *)sectionDataForArtworkAdditionalImages:(NSArray *)artworks
{
    ARSectionData *sectionData = [[ARSectionData alloc] init];

    // Note: we do only show a title for this section, when there's no artwork info
    BOOL showTitle = [self.artworkDataSource shouldShowArtworkInfoSection:artworks];
    if (!showTitle) {
        sectionData.headerView = [self headerViewForTitle:NSLocalizedString(@"Additional Images", @"Emailing Artwork Popover Additional Images title")];
    } else {
        sectionData.headerHeight = 2;
    }

    ARCellData *cellData = [[ARCellData alloc] initWithIdentifier:ARAdditionalImagesRowIdentifier];
    cellData.height = 84;

    @weakify(self);
    cellData.cellConfigurationBlock = ^(ARGroupedTableViewCell *cell) {
        @strongify(self);

        if (!self.additionalImagesSelectionView) {
            Artwork *artwork = self.artworks.firstObject;

            NSArray *images =  [artwork.images select:^BOOL(Image *image) {
                return artwork.mainImage != image;
            }];

            ARThumbnailImageSelectionView *selectionView = [self selectionViewForImages:images cell:cell];
            [cell.contentView addSubview:selectionView];
            [selectionView alignTop:@"4" leading:@"4" bottom:@"-4" trailing:@"-4" toView:cell.contentView];

            _additionalImagesSelectionView = selectionView;

            cell.accessoryView = nil;
            cell.isTopCell = !showTitle;
        }
    };

    [sectionData addCellData:cellData];
    return sectionData;
}

- (ARSectionData *)sectionDataForShowInstallShots:(NSArray *)artworks
{
    ARSectionData *sectionData = [[ARSectionData alloc] init];
    sectionData.headerView = [self headerViewForTitle:NSLocalizedString(@"Installation Shots", @"Emailing Artwork Popover Installation Shots Title")];

    ARCellData *cellData = [[ARCellData alloc] initWithIdentifier:ARInstallationShotRowIdentifier];
    cellData.height = 84;
    @weakify(self);
    cellData.cellConfigurationBlock = ^(ARGroupedTableViewCell *cell) {
        @strongify(self);
        if (!self.installationShotsSelectionView) {

            NSArray *images = [self.artworkDataSource installationShotsForArtworks:artworks context:self.context];

            ARThumbnailImageSelectionView *selectionView = [self selectionViewForImages:images cell:cell];
            [selectionView selectImages:self.installShots];
            
            [cell.contentView addSubview:selectionView];
            [selectionView alignTop:@"4" leading:@"4" bottom:@"-4" trailing:@"-4" toView:cell.contentView];
            _installationShotsSelectionView = selectionView;

            cell.accessoryView = nil;
            cell.isTopCell = YES;
        }
    };

    [sectionData addCellData:cellData];
    return sectionData;
}

- (ARThumbnailImageSelectionView *)selectionViewForImages:(NSArray *)images cell:(UITableViewCell *)cell
{
    ARThumbnailImageSelectionView *selectionView = [[ARThumbnailImageSelectionView alloc] initWithFrame:CGRectMake(4, 4, 300, 40)];
    selectionView.images = images;
    return selectionView;
}

- (ARCellData *)cellDataForTappableRowTitled:(NSString *)title defaultKey:(NSString *)defaultKey
{
    ARCellData *cellData = [[ARCellData alloc] initWithIdentifier:ARDefaultTickIdentifier];
    cellData.userInfo = defaultKey;

    @weakify(self, cellData);
    cellData.cellConfigurationBlock = ^(ARGroupedTableViewCell *cell) {
        @strongify(self, cellData);
        NSIndexPath *path = [self.tableViewData indexPathForCellData:cellData];
        [cell setIsTopCell:path.row == 0];

        cell.textLabel.text = title;

        BOOL selected = [self.userDefaults boolForKey:defaultKey];
        [cell setTickSelected:selected animated:NO];
    };

    cellData.cellSelectionBlock = ^(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self);
        ARTickedTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        
        BOOL selected = [self.userDefaults boolForKey:defaultKey];
        [self.userDefaults setBool:!selected forKey:defaultKey];
        [cell setTickSelected:!selected animated:YES];
    };

    return cellData;
}

- (NSString *)defaultKeyForIdentifier:(NSString *)identifier
{
    return [NSString stringWithFormat:@"ARMailShow%@Default", identifier];
}

- (NSString *)defaultKeyForDocumentIdentifier:(NSString *)identifier
{
    return [NSString stringWithFormat:@"ARMailIncludeFile%@Default", identifier];
}

- (ARTableHeaderView *)headerViewForTitle:(NSString *)title
{
    CGRect frame = CGRectMake(0, 0, 320, [ARTableHeaderView heightOfCell]);
    return [[ARTableHeaderView alloc] initWithFrame:frame title:title style:ARTableHeaderViewStyleLight];
}

- (UIView *)sendEmailButton
{
    ARFlatButton *button = [[ARFlatButton alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
    [button setTitle:@"Email" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tappedSend:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tappedSend:(ARFlatButton *)button
{
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Working…" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor artsyPurple] forState:UIControlStateNormal];
    [button setBorderColor:[UIColor artsyPurple] forState:UIControlStateNormal];

    [self emailArtworks];
}

- (void)emailArtworks
{
    if ([self.hostViewController respondsToSelector:@selector(dismissPopoversAnimated:)]) {
        [(id)self.hostViewController dismissPopoversAnimated:YES];
    }

    [AREmailComposer emailArtworksFromViewController:self.hostViewController withEmailSettings:[self emailSettings]];
}

- (BOOL)hasAdditionalOptions
{
    BOOL hasItems = NO;
    NSInteger numberOfSections = [self.tableView numberOfSections];
    for (NSInteger i = 0; i < numberOfSections; i++) {
        hasItems = hasItems || [self.tableView numberOfRowsInSection:i] > 0;
    }

    return hasItems;
}

+ (BOOL)canEmailArtworks
{
    return [MFMailComposeViewController canSendMail];
}

+ (void)presentNoMailAccountAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Email Account", @"No Email Account")
                                                    message:NSLocalizedString(@"You do not have an email account set up on this device.", @"Message for no email account alert.")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Back", @"Cancel button for no email account set up")
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)hasSelected:(NSString *)type
{
    return [self.userDefaults boolForKey:[self defaultKeyForIdentifier:type]];
}

- (AREmailSettings *)emailSettings
{
    AREmailSettings *settings = [[AREmailSettings alloc] init];
    settings.artworks = self.artworks;

    settings.showSupplementaryInformation = [self hasSelected:@"Supplementary Information"];
    settings.showInventoryID = [self hasSelected:@"Inventory ID"];

    BOOL showPublicPrice = [self.artworkDataSource artworksShouldShowPrice:self.artworks];
    NSInteger index = [self.userDefaults integerForKey:[self defaultKeyForIdentifier:@"Price Type"]];

    // If we're not showing the price
    if (!showPublicPrice && index > 0) {
        index++;
    }
    settings.priceType = index;

    if (self.installationShotsSelectionView) {
        NSIndexSet *selectedIndexes = self.installationShotsSelectionView.selectedIndexes;
        NSArray *installationShots = [self.artworkDataSource installationShotsForArtworks:self.artworks context:self.context];
        settings.installationShots = [installationShots objectsAtIndexes:selectedIndexes];
    }

    if (self.additionalImagesSelectionView) {
        NSIndexSet *selectedIndexes = self.additionalImagesSelectionView.selectedIndexes;
        NSArray *images = [[self.artworks.firstObject sortedImages] select:^BOOL(Image *image) {
            return image.mainImageForArtwork == nil;
        }];
        settings.additionalImages = [images objectsAtIndexes:selectedIndexes];
    }

    NSArray *documentContainers = [self.artworkDataSource arrayOfRelatedShowDocumentContainersForArtworks:self.artworks documents:self.documents];

    NSArray *allDocs = [[[documentContainers map:^id(NSObject<ARDocumentContainer> *container) {
        return [container sortedDocuments];

    }] flatten] select:^BOOL(Document *document) {
        return [self.userDefaults boolForKey:[self defaultKeyForDocumentIdentifier:document.slug]];
    }];

    settings.documents = [allDocs unique];
    return settings;
}

- (NSUserDefaults *)userDefaults
{
    return _userDefaults ?: [NSUserDefaults standardUserDefaults];
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, self.tableView.contentSize.height + 74);
}

@end

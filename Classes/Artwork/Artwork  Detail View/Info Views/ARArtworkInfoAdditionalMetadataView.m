#import "ARArtworkInfoAdditionalMetadataView.h"
#import "Artwork+HTMLTexts.h"
#import "NSString+StripHTML.h"
#import <Artsy+UILabels/Artsy+UILabels.h>
#import "EditionSet.h"
#import <ORStackView/ORStackView.h>
#import "NSString+NiceAttributedStrings.h"
#import "AROptions.h"


@interface ARArtworkInfoAdditionalMetadataView ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, assign) CGFloat columnWidth;
@end


@implementation ARArtworkInfoAdditionalMetadataView

- (instancetype)initWithArtwork:(Artwork *)artwork preferredWidth:(CGFloat)preferredWidth split:(BOOL)split
{
    return [self initWithArtwork:artwork preferredWidth:preferredWidth split:split defaults:nil];
}

- (instancetype)initWithArtwork:(Artwork *)artwork preferredWidth:(CGFloat)preferredWidth split:(BOOL)split defaults:(NSUserDefaults *)defaults
{
    self = [super init];

    self.centerMargin = 20;
    self.itemsPerSplitToggle = 2;
    self.defaults = defaults;

    NSMutableArray *artworkTitles = [[NSMutableArray alloc] init];
    NSMutableArray *artworkTexts = [[NSMutableArray alloc] init];

    if ([artwork.signature length]) {
        [artworkTitles addObject:@"Signature"];
        [artworkTexts addObject:[artwork.signature stringByStrippingHTML]];
    }

    if ([artwork.provenance length]) {
        [artworkTitles addObject:@"Provenance"];
        [artworkTexts addObject:[artwork.htmlProvenance stringByStrippingHTML]];
    }

    if ([artwork.exhibitionHistory length]) {
        [artworkTitles addObject:@"Exhibition History"];
        [artworkTexts addObject:[artwork.htmlExhibitionHistory stringByStrippingHTML]];
    }

    if ([artwork.literature length]) {
        [artworkTitles addObject:@"Literature"];
        [artworkTexts addObject:[artwork.htmlLiterature stringByStrippingHTML]];
    }

    if ([artwork.info length]) {
        [artworkTitles addObject:@"About the Artwork"];
        [artworkTexts addObject:[artwork.htmlInfo stringByStrippingHTML]];
    }

    if ([artwork.imageRights length]) {
        [artworkTitles addObject:@"Image Rights"];
        [artworkTexts addObject:[artwork.htmlImageRights stringByStrippingHTML]];
    }

    if ([artwork.series length]) {
        [artworkTitles addObject:@"Series"];
        [artworkTexts addObject:[artwork.htmlSeries stringByStrippingHTML]];
    }

    if ([artwork.inventoryID length]) {
        [artworkTitles addObject:@"Inventory ID"];
        [artworkTexts addObject:artwork.inventoryID];
    }

    if ([artwork.confidentialNotes length] && [self showConfidentialNotes]) {
        [artworkTitles addObject:@"Confidential Notes"];
        [artworkTexts addObject:[artwork.confidentialNotes stringByStrippingHTML]];
    }

    self.isSplit = split && (artworkTexts.count != 1 || (artwork.editionSets.count > 1 && artworkTexts.count));
    self.columnWidth = self.isSplit ? (preferredWidth / 2) - self.centerMargin : preferredWidth;

    if (artwork.editionSets.count > 1) {
        UILabel *editionsTitle = [self titleLabelWithText:@"Editions"];
        [self addSubview:editionsTitle withPrecedingMargin:0 sideMargin:0];

        UIView *editionStack = [self stackViewForEditionSets:artwork.editionSets];
        [self addSubview:editionStack withPrecedingMargin:6 sideMargin:0];
    }

    [artworkTitles eachWithIndex:^(NSString *title, NSUInteger index) {
        UILabel *titleLabel = [self titleLabelWithText:title];
        BOOL isATopTitle = [self isATopTitleAtIndex:index editions:artwork.editionSets.count];
        [self addSubview:titleLabel withPrecedingMargin:isATopTitle ? 0 : 28 sideMargin:0];

        UILabel *bodyLabel = [self bodyLabelWithText:artworkTexts[index]];
        [self addSubview:bodyLabel withPrecedingMargin:6 sideMargin:0];
    }];

    self.backgroundColor = [UIColor artsyBackgroundColor];

    return self;
}

- (BOOL)isATopTitleAtIndex:(NSUInteger)index editions:(BOOL)editions
{
    if (editions) return self.isSplit && index == 0;
    return (index == 0) || (self.isSplit && index == 1);
}

- (UILabel *)titleLabelWithText:(NSString *)text
{
    UILabel *titleLabel = [[ARSansSerifLabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = text;
    titleLabel.textColor = [UIColor artsyForegroundColor];
    titleLabel.backgroundColor = [UIColor artsyBackgroundColor];
    titleLabel.numberOfLines = 0;
    titleLabel.preferredMaxLayoutWidth = self.columnWidth;
    return titleLabel;
}

- (UILabel *)bodyLabelWithText:(NSString *)text
{
    UILabel *bodyLabel = [[ARSerifLabel alloc] initWithFrame:CGRectZero];
    bodyLabel.attributedText = [text attributedStringWithLineSpacing:6.0];

    bodyLabel.textColor = [UIColor artsyForegroundColor];
    bodyLabel.backgroundColor = [UIColor artsyBackgroundColor];
    bodyLabel.preferredMaxLayoutWidth = self.columnWidth;
    bodyLabel.numberOfLines = 0;
    return bodyLabel;
}

- (ORStackView *)stackViewForEditionSets:(NSSet *)editionSets
{
    ORStackView *editionsView = [[ORStackView alloc] init];

    NSSortDescriptor *priceSort = [NSSortDescriptor sortDescriptorWithKey:@"internalPrice" ascending:NO];
    NSArray *editions = [editionSets sortedArrayUsingDescriptors:@[ priceSort ]];

    [editions eachWithIndex:^(EditionSet *set, NSUInteger editionIndex) {
        NSArray *editionAttributes = [set editionAttributes];

        if ([self showPriceOfEditionSet:set] && set.internalPrice.length) {
            editionAttributes = [editionAttributes arrayByAddingObject:set.internalPrice];
        }

        [editionAttributes eachWithIndex:^(NSString *attribute, NSUInteger attrIndex) {
            UILabel *label = [self bodyLabelWithText:attribute];
            [editionsView addSubview:label withPrecedingMargin:(attrIndex == 0 && !(editionIndex == 0)) ? 25 : 2 sideMargin:0];
        }];
    }];

    return editionsView;
}

- (BOOL)showConfidentialNotes
{
    /// If presentation mode is off, always show notes. Otherwise, check the confidential notes toggle.
    return [self.defaults boolForKey:ARPresentationModeOn] ? ![self.defaults boolForKey:ARHideConfidentialNotes] : YES;
}

- (BOOL)showPriceOfEditionSet:(EditionSet *)set
{
    /// Check if all prices should be hidden, and if not, check if the work is sold
    BOOL shouldHidePrice = [self.defaults boolForKey:ARHideAllPrices] || ([set.availability isEqualToString:ARAvailabilitySold] && [self.defaults boolForKey:ARHidePricesForSoldWorks]);

    return [self.defaults boolForKey:ARPresentationModeOn] ? !shouldHidePrice : YES;
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end

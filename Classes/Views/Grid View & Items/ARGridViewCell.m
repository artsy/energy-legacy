

#import "ARGridViewCell.h"
#import "ARDateLabel.h"
#import "ARHighlightableImageView.h"
#import "UIImageView+ImageFrame.h"
#import "ARImageGridViewItem.h"

const UIEdgeInsets ContentInsets = {.top = 0, .left = 6, .right = 6, .bottom = 0};
const UIEdgeInsets PhoneContentInsets = {.top = 0, .left = 0, .right = 0, .bottom = 4};

NSString *ARGridViewStateSelectable = @"selectable";
NSString *ARGridViewStateMultiSelectable = @"multi-selectable";
NSString *ARGridViewStateMultiSelectableDisabled = @"multi-disabled";
NSString *ARGridViewStateMultiSelectableSelected = @"multi-seleced";


@interface ARGridViewCell ()
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) ARDateLabel *subtitleLabel;
@property (strong, nonatomic, readonly) ARHighlightableImageView *imageView;

@property (assign, nonatomic, readonly) BOOL isMultiSelectable;
@property (assign, nonatomic, readonly) BOOL isVisuallySelected;
@end


@implementation ARGridViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.selectedBackgroundView = [[UIView alloc] init];
    self.opaque = YES;
    self.contentView.opaque = YES;

    ARHighlightableImageView *imageView = [[ARHighlightableImageView alloc] initWithFrame:[self defaultImageFrame]];
    imageView.imageBackgroundColor = [UIColor darkGrayColor];
    _imageView = imageView;

    [self.contentView addSubview:self.imageView];

    UILabel *titleLabel = [self createTitleLabel];
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];

    ARDateLabel *subtitleLabel = [self createSubtitleLabel];
    _subtitleLabel = subtitleLabel;
    [self.contentView addSubview:subtitleLabel];

    [self setSuppressItalics:NO];

    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    _imageView.image = nil;
    _imageView.imageBackgroundColor = [UIColor darkGrayColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;

    _titleLabel.text = @"";
    _subtitleLabel.text = @"";

    _item = nil;
    _aspectRatio = 1;
}

#pragma mark - Setup

- (UILabel *)createTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    CGFloat fontSize = [UIDevice isPad] ? ARFontSansRegular : ARPhoneFontSansRegular;
    titleLabel.font = [UIFont sansSerifFontWithSize:fontSize];
    titleLabel.textColor = [UIColor artsyForegroundColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.opaque = YES;
    titleLabel.userInteractionEnabled = YES;
    titleLabel.clipsToBounds = NO;
    titleLabel.preferredMaxLayoutWidth = self.imageSize.width;
    titleLabel.numberOfLines = 0;
    return titleLabel;
}

- (ARDateLabel *)createSubtitleLabel
{
    ARDateLabel *subtitleLabel = [[ARDateLabel alloc] initWithFrame:CGRectZero];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.textColor = [UIColor artsyForegroundColor];
    subtitleLabel.opaque = YES;
    return subtitleLabel;
}

#pragma mark - Setters

- (void)setItem:(id<ARGridViewItem>)item
{
    _item = item;

    // If we have an artwork with no date, suppress date formatting
    if ([item isKindOfClass:Artwork.class]) {
        if (![(Artwork *)item date].length) {
            self.subtitleLabel.suppressDateFormatting = YES;
        }
    }
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
    _aspectRatio = aspectRatio;
    self.imageView.aspectRatio = aspectRatio;
    [self setNeedsLayout];
}

- (void)setImageURL:(NSURL *)imageURL savingLocallyAtPath:(NSString *)path
{
    [self.imageView.imageView setupWithFilepath:path url:imageURL];
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image
{
    self.imageView.imageBackgroundColor = [UIColor artsyBackgroundColor];
    self.imageView.tintColor = [UIColor artsyForegroundColor];
    self.imageView.image = image;
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title
{
    _title = title.uppercaseString;
    self.titleLabel.text = title.uppercaseString;
    [self setNeedsLayout];
}

- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    self.subtitleLabel.text = subtitle;
    [self setNeedsLayout];
}

- (void)setAttributedSubtitle:(NSAttributedString *)subtitle
{
    // Something is weird about the colors here.
    _attributedSubtitle = subtitle;
    self.subtitleLabel.attributedText = subtitle;
    [self setNeedsLayout];
}

- (void)setSuppressItalics:(BOOL)suppressItalics
{
    _suppressItalics = suppressItalics;

    CGFloat fontSize = [UIDevice isPad] ? ARFontSerif : ARPhoneFontSerif;
    if (self.suppressItalics) {
        self.subtitleLabel.font = [UIFont serifFontWithSize:fontSize];
    } else {
        self.subtitleLabel.font = [UIFont serifItalicFontWithSize:fontSize];
    }
}

#pragma mark - Getters

- (CGSize)imageSize
{
    return CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 60);
}

- (UIEdgeInsets)contentInsets
{
    return ([UIDevice isPad]) ? ContentInsets : PhoneContentInsets;
}

- (CGRect)defaultImageFrame
{
    CGRect imageFrame;
    imageFrame.size.width = [self imageSize].width - [self contentInsets].right - [self contentInsets].left;
    imageFrame.size.height = [self imageSize].height;
    imageFrame.origin.x = [self contentInsets].left;
    imageFrame.origin.y = [self contentInsets].top;
    return imageFrame;
}

#pragma - mark image size management

- (void)setIsMultiSelectable:(BOOL)selectable animated:(BOOL)animated
{
    _isMultiSelectable = selectable;

    CGFloat inset = selectable ? 10 : 0;
    [self.imageView setContentInsetX:inset insetY:inset animated:animated];

    if (!selectable) {
        [self setVisuallySelected:NO animated:animated];
    }

    [UIView animateIf:animated duration:ARAnimationQuickDuration:^{
        _imageView.alpha = selectable ? 0.9 : 1;
    }];
}

- (void)setVisuallySelected:(BOOL)selected animated:(BOOL)animated
{
    _isVisuallySelected = selected;
    if (selected) {
        [self.imageView setContentInsetX:16 insetY:16 animated:animated];
        [self.imageView addBadge:[UIImage imageNamed:@"Tick"] animated:animated];
    } else {
        CGFloat inset = self.isMultiSelectable ? 10 : 0;
        [self.imageView setContentInsetX:inset insetY:inset animated:animated];
        [self.imageView removeBadgeAnimated:animated];
    }
}

static CGFloat ArtistBottomMargin = 1;
static CGFloat TitleMaxLabelHeight = 40;
static CGFloat SubTitleLabelHeight = 24;

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize imageSize = [self imageSize];
    UIEdgeInsets contentInsets = [self contentInsets];

    if ([self.title length]) {
        self.titleLabel.frame = (CGRect){
            contentInsets.left,
            contentInsets.top + imageSize.height + contentInsets.bottom,
            CGRectGetWidth(self.bounds) - contentInsets.left - contentInsets.right,
            MIN(self.titleLabel.intrinsicContentSize.height, TitleMaxLabelHeight)};

    } else {
        self.titleLabel.frame = (CGRect){
            contentInsets.left,
            contentInsets.top + imageSize.height + contentInsets.bottom,
            CGRectGetWidth(self.bounds) - contentInsets.left - contentInsets.right,
            0};
    }

    self.subtitleLabel.frame = (CGRect){
        contentInsets.left,
        CGRectGetMaxY(_titleLabel.frame) + ArtistBottomMargin,
        CGRectGetWidth(self.bounds) - contentInsets.left - contentInsets.right,
        SubTitleLabelHeight};

    self.imageView.frame = [self defaultImageFrame];
}

#pragma mark - ARGridView+CoverHandling.m

- (CGRect)imageFrame
{
    return self.imageView.imageView.frameForImage;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // NO-OP - used in subclasses
}

@end

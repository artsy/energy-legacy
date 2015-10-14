#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "ARAddArtworksTableViewCell.h"


@implementation ARAddArtworksTableViewCell

- (void)setupWithArtist:(Artist *)artist
{
    self.contentView.backgroundColor = [UIColor artsyBackgroundColor];
    self.backgroundColor = [UIColor artsyBackgroundColor];
    self.textLabel.textColor = [UIColor artsyForegroundColor];

    CGFloat fontSize = [UIDevice isPad] ? ARFontSansLarge : ARFontSansSmall;
    self.textLabel.font = [UIFont sansSerifFontWithSize:fontSize];
    self.textLabel.numberOfLines = 0;

    self.imageView.image = [UIImage imageWithContentsOfFile:[artist gridThumbnailPath:ARFeedImageSizeSquareKey]];
    self.textLabel.text = [[artist name] uppercaseString];

    if (!self.accessoryView) {
        NSString *path = [[NSBundle bundleForClass:ARLabelWithChevron.class] pathForResource:@"Chevron_Gray" ofType:@"png"];
        UIImage *chevron = [UIImage imageWithContentsOfFile:path];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:chevron];
        self.accessoryView = imageView;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = CGRectInset(self.imageView.frame, 14, 14);
    self.accessoryView.frame = CGRectOffset(self.accessoryView.frame, -8, 0);
}

@end

#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "NSAttributedString+Artsy.h"


@implementation NSAttributedString (Artsy)

+ (NSAttributedString *)titleAndDateStringForArtwork:(Artwork *)artwork
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];

    NSString *title = artwork.title ?: @"Untitled";
    NSMutableAttributedString *titleAndDate = [[NSMutableAttributedString alloc] initWithString:title attributes:@{
        NSParagraphStyleAttributeName : paragraphStyle,
        NSFontAttributeName : [UIFont serifItalicFontWithSize:16]
    }];

    if (artwork.date.length > 0) {
        NSString *formattedTitleDate = [@", " stringByAppendingString:artwork.date];
        NSAttributedString *andDate = [[NSAttributedString alloc] initWithString:formattedTitleDate attributes:@{
            NSFontAttributeName : [UIFont serifFontWithSize:16]
        }];
        [titleAndDate appendAttributedString:andDate];
    }

    return titleAndDate.copy;
}

+ (NSAttributedString *)artistStringForArtwork:(Artwork *)artwork
{
    if (artwork.artist.name == nil) return nil;

    return [[NSAttributedString alloc] initWithString:artwork.artist.name.uppercaseString attributes:@{
        NSFontAttributeName : [UIFont sansSerifFontWithSize:16]
    }];
}

@end

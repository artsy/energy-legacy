
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

    // Do we show the dot?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:ARPresentationModeOn] || ![defaults boolForKey:ARHideArtworkAvailability]) {
        NSMutableAttributedString *dotString = [[NSMutableAttributedString alloc] initWithString:@" •"];

        UIColor *color = [Artwork colorForAvailabilityState:artwork.availabilityState];
        [dotString addAttributes:@{
            NSFontAttributeName : [UIFont serifItalicFontWithSize:22],
            NSForegroundColorAttributeName : color,
            NSBaselineOffsetAttributeName : @(-2)
        } range:NSMakeRange(0, 2)];
        [titleAndDate appendAttributedString:dotString];
    }

    return titleAndDate.copy;
}

+ (NSAttributedString *)artistStringForArtwork:(Artwork *)artwork
{
    return [[NSAttributedString alloc] initWithString:artwork.artistDisplayString.uppercaseString attributes:@{
        NSFontAttributeName : [UIFont sansSerifFontWithSize:16]
    }];
}

@end

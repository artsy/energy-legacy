#import <Foundation/Foundation.h>


@interface NSAttributedString (Artsy)

+ (NSAttributedString *)titleAndDateStringForArtwork:(Artwork *)artwork;

+ (NSAttributedString *)artistStringForArtwork:(Artwork *)artwork;

@end

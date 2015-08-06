#import "Artwork.h"


@interface Artwork (HTMLTexts)

// Used in artwork views

- (NSString *)htmlExhibitionHistory;
- (NSString *)htmlProvenance;
- (NSString *)htmlInfo;
- (NSString *)htmlSignature;
- (NSString *)htmlLiterature;
- (NSString *)htmlImageRights;
- (NSString *)htmlSeries;

// These get called from markdown

- (NSString *)emailExhibitionHistory;
- (NSString *)emailLiterature;
- (NSString *)emailProvenance;
- (NSString *)emailAdditionalInfo;
- (NSString *)emailImageRights;
- (NSString *)emailSeries;
@end

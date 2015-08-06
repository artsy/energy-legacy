#import "Artwork+HTMLTexts.h"
#import "GHMarkdownParser.h"


@implementation Artwork (HTMLTexts)

static NSString *paragraphInlineStyle = @"<p style='font-family: Georgia, serif; font-weight:100;margin-bottom:0px;margin-top:0px;'>";
static NSString *supplementaryInlineStyle = @"<span style='font-size: 10px;vertical-align: middle;text-transform: uppercase;'>";
static NSString *supplementaryInlineTerminator = @"</span>";

- (NSString *)htmlerize:(NSString *)input
{
    // We can't have unstyled <p>s because they look ugly.
    NSString *result = [input.HTMLStringFromMarkdown stringByReplacingOccurrencesOfString:@"<p>" withString:paragraphInlineStyle];
    return result;
}

// Apply markdown, take out the first styled <p> and replace with a <p><span>title</span>
- (NSString *)emailerize:(NSString *)input withTitle:(NSString *)title
{
    NSString *initialPrefix = [NSString stringWithFormat:@"%@%@%@: %@", paragraphInlineStyle, supplementaryInlineStyle, title, supplementaryInlineTerminator];

    return [[self htmlerize:input] stringByReplacingCharactersInRange:NSMakeRange(0, paragraphInlineStyle.length) withString:initialPrefix];
}

- (NSString *)htmlExhibitionHistory
{
    return [self htmlerize:self.exhibitionHistory];
}

- (NSString *)htmlProvenance
{
    return [self htmlerize:self.provenance];
}

- (NSString *)htmlLiterature
{
    return [self htmlerize:self.literature];
}

- (NSString *)htmlSignature
{
    return [self htmlerize:self.signature];
}

- (NSString *)htmlInfo
{
    return [self htmlerize:self.info];
}

- (NSString *)htmlSeries
{
    return [self htmlerize:self.series];
}

- (NSString *)htmlImageRights
{
    return [self htmlerize:self.imageRights];
}

- (NSString *)htmlSafeDimensions
{
    return self.dimensionsInches;
}

- (NSString *)htmlSafeAlternativeDimensions
{
    return self.dimensionsCM;
}

- (NSString *)emailExhibitionHistory
{
    return [self emailerize:self.exhibitionHistory withTitle:@"Exhibition History"];
}

- (NSString *)emailLiterature
{
    return [self emailerize:self.literature withTitle:@"Literature"];
}

- (NSString *)emailProvenance
{
    return [self emailerize:self.provenance withTitle:@"Provenance"];
}

- (NSString *)emailAdditionalInfo
{
    return [self emailerize:self.info withTitle:@"Additional Info"];
}

- (NSString *)emailImageRights
{
    return [self emailerize:self.imageRights withTitle:@"Image Rights"];
}

- (NSString *)emailSeries
{
    return [self emailerize:self.series withTitle:@"Series"];
}

@end

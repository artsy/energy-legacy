#import "NSDictionary+ObjectForKey.h"
#import "ARFileUtils.h"


@implementation ShowDocument

+ (NSString *)folioSlug:(NSDictionary *)dictionary
{
    NSDictionary *showDict = [dictionary objectForKeyNotNull:ARFeedPartnerShowKey];
    if (showDict) {
        NSString *showSlug = [Show folioSlug:showDict];
        return [NSString stringWithFormat:@"%@-%@", showSlug, [dictionary onlyStringForKey:ARFeedDocumentSlug]];
    } else {
        return [super folioSlug:dictionary];
    }
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *showDict = [dictionary objectForKeyNotNull:ARFeedPartnerShowKey];
    if (showDict) {
        NSString *partnerSlug = [Partner currentPartnerID];
        NSString *parentSlug = [partnerSlug stringByAppendingFormat:@"-%@", [showDict objectForKeyNotNull:ARFeedIDKey]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slug == %@", parentSlug];
        self.slug = [NSString stringWithFormat:@"%@-%@", parentSlug, [dictionary onlyStringForKey:ARFeedDocumentSlug]];

        Show *showForDoc = [Show findFirstWithPredicate:predicate inContext:self.managedObjectContext];
        if (showForDoc) {
            self.show = showForDoc;
        }
    }

    // Call the Document's update with dict which sets all the normal iVars
    [super updateWithDictionary:dictionary];
}

- (NSString *)filePath
{
    NSString *slug = [Partner currentPartnerID];
    NSString *folder = [NSString stringWithFormat:@"%@/%@", slug, self.show.slug];
    return [ARFileUtils filePathWithFolder:folder documentFileName:self.filename];
}

- (NSString *)thumbnailFilePath
{
    NSString *slug = [Partner currentPartnerID];
    NSString *folder = [NSString stringWithFormat:@"%@/%@/thumbnails/", slug, self.show.slug];
    NSString *customThumbnailPath = [ARFileUtils filePathWithFolder:folder documentFileName:[self.slug stringByAppendingPathExtension:@"jpg"]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:customThumbnailPath];

    if (self.canGenerateThumbnail && fileExists) {
        return customThumbnailPath;
    } else {
        return [super thumbnailFilePath];
    }
}

@end

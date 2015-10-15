#import "NSDictionary+ObjectForKey.h"
#import "ARFileUtils.h"


@implementation ArtistDocument

+ (NSString *)folioSlug:(NSDictionary *)dictionary
{
    NSDictionary *artistDict = [dictionary objectForKeyNotNull:ARFeedArtistKey];
    if (artistDict) {
        NSString *artistSlug = [Artist folioSlug:artistDict];
        return [NSString stringWithFormat:@"%@-%@", artistSlug, [dictionary onlyStringForKey:ARFeedDocumentSlug]];
    } else {
        return [super folioSlug:dictionary];
    }
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *artistDict = [dictionary objectForKeyNotNull:ARFeedArtistKey];

    if (artistDict) {
        NSString *parentSlug = [artistDict objectForKeyNotNull:ARFeedIDKey];
        self.slug = [NSString stringWithFormat:@"%@-%@", parentSlug, [dictionary onlyStringForKey:ARFeedDocumentSlug]];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slug == %@", parentSlug];
        Artist *artistForDoc = [Artist findFirstWithPredicate:predicate inContext:self.managedObjectContext];
        if (artistForDoc) {
            self.artist = artistForDoc;
        }
    }

    // Call the Document's update with dict which sets all the normal iVars
    [super updateWithDictionary:dictionary];
}

- (NSString *)filePath
{
    NSString *folder = [NSString stringWithFormat:@"%@/%@", [Partner currentPartnerID], self.artist.slug];
    return [ARFileUtils filePathWithFolder:folder documentFileName:self.filename];
}

- (NSString *)customThumbnailFilePath
{
    NSString *folder = [NSString stringWithFormat:@"%@/%@/thumbnails/", [Partner currentPartnerID], self.artist.slug];
    return [ARFileUtils filePathWithFolder:folder documentFileName:[self.slug stringByAppendingPathExtension:@"jpg"]];
}

- (NSString *)thumbnailFilePath
{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:customThumbnailFilePath];

    if (self.canGenerateThumbnail && fileExists) {
        return customThumbnailFilePath;
    } else {
        return [super thumbnailFilePath];
    }
}

@end

#import "NSDictionary+ObjectForKey.h"
#import "ARFileUtils.h"
#import "ARRouter.h"
#import "NSFileManager+SimpleDeletion.h"


@implementation Document

- (NSString *)description
{
    return [NSString stringWithFormat:@"Document : %@ ( %@ )", self.filename, self.humanReadableSize];
}

+ (NSString *)folioSlug:(NSDictionary *)aDictionary
{
    return [aDictionary onlyStringForKey:ARFeedDocumentSlug];
}

- (void)updateWithDictionary:(NSDictionary *)aDictionary
{
    // As by this point either the ArtistDoc or ShowDoc should have
    // set the slug in their own overrode method not having it by here
    // is indeed worrying.

    if (!self.slug) {
        ARSyncLog(@"no slug set for document %@ -- this is worrying", [aDictionary onlyStringForKey:ARFeedDocumentSlug]);
    }

    self.url = [aDictionary onlyStringForKey:ARFeedDocumentURL];
    self.filename = [aDictionary onlyStringForKey:ARFeedDocumentFileName];
    self.size = [aDictionary onlyNumberForKey:ARFeedDocumentSize];
    self.title = [aDictionary onlyStringForKey:ARFeedTitleKey];
    self.humanReadableSize = [ARFileUtils humanReadableStringFromBytes:self.size.doubleValue];
}

- (NSString *)filePath
{
    NSAssert(false, @"filePath called on Document instead of subclasses");
    return nil;
}

- (NSString *)thumbnailFilePath
{
    NSString *extension = [self.filename pathExtension];
    if ([@[ @"pdf", @"txt", @"doc", @"docx" ] containsObject:extension]) {
        return [self genericTextDocumentFilePath];
    } else {
        return [self genericDocumentFilePath];
    }
}

- (NSString *)customThumbnailFilePath
{
    return [self thumbnailFilePath];
}

- (NSString *)genericTextDocumentFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"FileIcon_textdoc" ofType:@"png"];
}

- (NSString *)genericDocumentFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"FileIcon_generic" ofType:@"png"];
}

- (NSString *)mimeType
{
    //http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database

    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[self.filePath pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);

    NSString *mimeType = [(__bridge NSString *)MIMEType copy];

    CFRelease(UTI);
    CFRelease(MIMEType);
    return mimeType;
}

- (NSURL *)fullURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", [ARRouter baseURL], @"/api/v1", self.url]];
}

- (NSString *)presentableFileName
{
    if (self.title) return self.title;

    // kill all preceding whitespace
    NSRange range = [self.filename rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
    NSString *name = [self.filename stringByReplacingCharactersInRange:range withString:@""];

    // replace all dots / underlines with spaces
    NSArray *removeStrings = @[ @".", @"_" ];
    for (NSString *remove in removeStrings) {
        name = [name stringByReplacingOccurrencesOfString:remove withString:@" "];
    }

    // split based on last %2 ( see #810 )
    name = [name componentsSeparatedByString:@"%2"].lastObject;

    return name;
}

- (NSString *)emailableFileName
{
    return [self.filename componentsSeparatedByString:@"%2"].lastObject;
}

- (BOOL)canGenerateThumbnail
{
    NSString *extension = [self.filename pathExtension];
    return [@[ @"pdf", @"jpg", @"jpeg", @"gif", @"png" ] containsObject:extension];
}

#pragma mark -
#pragma mark ARGridViewItem methods

- (NSString *)gridTitle
{
    return [self presentableFileName];
}

- (NSString *)gridSubtitle
{
    return (self.humanReadableSize) ? self.humanReadableSize : @"";
}

- (float)aspectRatio
{
    return 1;
}

- (NSString *)gridThumbnailPath:(NSString *)size
{
    return [self thumbnailFilePath];
}

- (NSURL *)gridThumbnailURL:(NSString *)size
{
    return [NSURL fileURLWithPath:[self thumbnailFilePath]];
}

#pragma mark -
#pragma mark QuickLookItem methods

- (NSURL *)previewItemURL
{
    return [NSURL fileURLWithPath:self.filePath];
}

- (NSString *)previewItemTitle
{
    return self.gridTitle;
}

- (void)deleteDocument
{
    [[NSFileManager defaultManager] deleteFileAtPath:self.thumbnailFilePath];
    [[NSFileManager defaultManager] deleteFileAtPath:self.filePath];
    [self deleteEntity];
}

@end

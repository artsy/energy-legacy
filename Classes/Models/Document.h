#import "ARManagedObject.h"
#import "ARGridViewItem.h"
#import <QuickLook/QuickLook.h>
#import "_Document.h"


@interface Document : _Document <ARGridViewItem, QLPreviewItem, ARMultipleSelectionItem>

- (NSString *)filePath;
- (NSString *)genericTextDocumentFilePath;
- (NSString *)genericDocumentFilePath;

- (NSString *)mimeType;

- (BOOL)canGenerateThumbnail;
- (NSString *)thumbnailFilePath;
- (NSString *)newThumbnailFilePath;

/// For showing to users
- (NSString *)presentableFileName;

/// For the filename to send to users
- (NSString *)emailableFileName;

- (NSURL *)fullURL;

- (void)deleteDocument;

@end

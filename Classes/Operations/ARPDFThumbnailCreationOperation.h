#import <Foundation/Foundation.h>

/// The ARPDFThumbnailCreationOperation will take a path of a PDF
/// and extract out the first page as a JPG. It presumes that you
/// will always want it size-bound to the frame and keeping the
/// aspect ratio constant.


@interface ARPDFThumbnailCreationOperation : NSOperation

+ (ARPDFThumbnailCreationOperation *)operationWithPDFSourcePath:(NSString *)sourcePath andDestinationPath:(NSString *)destinationPath;

@end

@class Image;
@class Document;

/// The ARThumbnailDownloadOperation is an operation to resize images for thumbnailing.
/// Its functionality is exposed as taking the model and dealing with whatever it needs.


@interface ARThumbnailCreationOperation : NSOperation
+ (ARThumbnailCreationOperation *)operationWithImage:(Image *)image andSize:(NSString *)theSize;

+ (ARThumbnailCreationOperation *)operationWithDocument:(Document *)document;
@end

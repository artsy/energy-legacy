//  Image cropping based off http://brian-erickson.com/uiimage-thumbnails-in-objective-c-for-the-iph

//  The small version is the image that is instantly loaded and then the higher resolution image
//  gets set over it.

#import "ARThumbnailCreationOperation.h"
#import "ARFileUtils.h"

float RetinaImageViewSize = 460;
float LegacyImageViewSize = 230;
float SmallImageViewSize = 115;


@implementation ARThumbnailCreationOperation {
    // When given an Image
    Image *_image;
    NSString *_slug;
    NSString *_format;

    // When given a Document
    NSString *_source;
    NSString *_destination;
}

+ (ARThumbnailCreationOperation *)operationWithImage:(Image *)image andSize:(NSString *)theSize
{
    return [[self alloc] initWithImage:image andSize:theSize];
}

+ (ARThumbnailCreationOperation *)operationWithDocument:(Document *)document
{
    return [[self alloc] initWithDocument:document];
}

- (ARThumbnailCreationOperation *)initWithImage:(Image *)image andSize:(NSString *)theSize
{
    if (self = [super init]) {
        _image = image;
        _slug = image.slug;
        _format = theSize;
    }
    return self;
}

- (ARThumbnailCreationOperation *)initWithDocument:(Document *)document
{
    if (self = [super init]) {
        _source = document.filePath;
        _destination = document.customThumbnailFilePath;
    }
    return self;
}

- (void)main
{
    BOOL isRetina = [[UIScreen mainScreen] scale] > 1;
    CGFloat size = isRetina ? RetinaImageViewSize : LegacyImageViewSize;

    // Are we a generic thumbnail request?
    if (_source && _destination) {
        [self resizeImageFrom:_source to:_destination toSize:size withCrop:YES];
    }

    // Or are we specifically generating the image thumbnails
    if (_image) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", _slug, ARFeedImageSizeLargerKey];
        NSString *sourcePath = [ARFileUtils filePathWithFolder:ImageDirectoryName
                                                      filename:imageName
                                                     extension:ImageFileExtension];

        NSString *smallestName = [NSString stringWithFormat:@"%@_%@_mini", _slug, _format];
        NSString *smallestPath = [ARFileUtils filePathWithFolder:ImageDirectoryName
                                                        filename:smallestName
                                                       extension:ImageFileExtension];

        NSString *normalName = [NSString stringWithFormat:@"%@_%@", _slug, _format];
        NSString *normalPath = [ARFileUtils filePathWithFolder:ImageDirectoryName
                                                      filename:normalName
                                                     extension:ImageFileExtension];

        BOOL useSquareCrop = (_format == ARFeedImageSizeSquareKey);

        // We already have the image downloaded, ATM, so in retina we rm the
        // original file so that we can replace with the 460px larger thumbnail
        if (isRetina) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:normalPath error:&error];

            // 4 is file not found
            if (error && error.code != 4) {
                ARSyncLog(@"Error deleting original thumbnail, will not get a replacement for retina - %@", error.localizedDescription);
            }
        }

        if (![[NSFileManager defaultManager] fileExistsAtPath:normalPath]) {
            [self resizeImageFrom:sourcePath to:normalPath toSize:size withCrop:useSquareCrop];
        }

        if (![[NSFileManager defaultManager] fileExistsAtPath:smallestPath]) {
            [self resizeImageFrom:sourcePath to:smallestPath toSize:SmallImageViewSize withCrop:useSquareCrop];
        }
    }
}

- (void)resizeImageFrom:(NSString *)fromPath to:(NSString *)toPath toSize:(CGFloat)dimension withCrop:(BOOL)crop
{
    @try {
        ///  UIImageJPEGRepresentation has been known to crash in iOS8

        UIImage *image = [UIImage imageWithContentsOfFile:fromPath];
        CGSize size = image.size;
        CGSize croppedSize;
        CGFloat offsetX = 0.0;
        CGFloat offsetY = 0.0;
        CGImageRef imageRef;
        CGRect rect;
        if (crop) {
            // check the size of the image, we want to make it
            // a square with sides the size of the smallest dimension
            if (size.width > size.height) {
                offsetX = (size.height - size.width) / 2;
                croppedSize = CGSizeMake(size.height, size.height);
            } else {
                offsetY = (size.width - size.height) / 2;
                croppedSize = CGSizeMake(size.width, size.width);
            }

            // Crop the image before resize
            CGRect clippedRect = CGRectMake(-offsetX, -offsetY, croppedSize.width, croppedSize.height);
            imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
            rect = CGRectMake(0.0, 0.0, dimension, dimension);

        } else {
            imageRef = CGImageRetain([image CGImage]);
            rect = CGRectMake(0.0, 0.0, dimension, dimension);


            //we're making sure these are intgral and even because otherwise
            //they'll be misaligned while centered
            //which forces an alphablend on the fractional pixels
            //http://www.ultrajoke.net/2011/12/cancel-dispatch_after/
            if (size.width > size.height) {
                rect.size.height = floor(dimension * (size.height / size.width));
                if (fmod(rect.size.height, 2.f) != 0) {
                    rect.size.height -= 1.f;
                }
            } else {
                rect.size.width = floor(dimension * (size.width / size.height));
                if (fmod(rect.size.width, 2.f) != 0) {
                    rect.size.width -= 1.f;
                }
            }
        }

        //we've compensated for the sizes already, so
        //we'll draw with a scale factor of 1
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.f);
        [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
        UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);

        // Done Resizing
        NSData *imageData = UIImageJPEGRepresentation(thumbnail, 0.8f);
        [imageData writeToFile:toPath atomically:YES];
    }

    @catch (NSException *exception) {
        ARErrorLog(@"Caught Error in creating a thumbnail for a work");
        [self cancel];
    }
}

@end

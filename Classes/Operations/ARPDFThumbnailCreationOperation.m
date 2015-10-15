#import "ARPDFThumbnailCreationOperation.h"

float RetinaImageSize = 460;
float LegacyImageSize = 230;


@implementation ARPDFThumbnailCreationOperation {
    NSString *_source;
    NSString *_destination;
}

+ (ARPDFThumbnailCreationOperation *)operationWithPDFSourcePath:(NSString *)sourcePath andDestinationPath:(NSString *)destinationPath
{
    return [[self alloc] initWithSourcePath:sourcePath andDestinationPath:destinationPath];
}

- (instancetype)initWithSourcePath:(NSString *)source andDestinationPath:(NSString *)destination
{
    if (self = [super init]) {
        _source = source;
        _destination = destination;
    }
    return self;
}

- (void)main
{
    // based on http://stackoverflow.com/questions/4504834/how-to-generate-a-thumbnails-form-a-pdf-document-with-iphone-sdk

    [self performSelector:@selector(cancelRendering) withObject:nil afterDelay:15];

    NSURL *sourceFileUrl = [NSURL fileURLWithPath:_source];
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)sourceFileUrl);
    if (!pdfDocument) {
        ARSyncLog(@"Couldnt load PDF at %@", _source);
        [self cancelRendering];
        return;
    }

    BOOL isRetina = [[UIScreen mainScreen] scale] > 1;
    CGFloat size = isRetina ? RetinaImageSize : LegacyImageSize;
    CGRect frameRect = CGRectMake(0, 0, size, size);
    CGPDFPageRef page;

    // Grab the first PDF page
    page = CGPDFDocumentGetPage(pdfDocument, 1);

    // Get the page size
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);

    // Create a context that is the aspect sized rect, but ignore the x/y
    CGRect imageFrame = [self aspectFittedRect:pageRect max:frameRect];
    imageFrame.origin.x = imageFrame.origin.y = 0;

    UIGraphicsBeginImageContext(imageFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *thumbnailImage = nil;

    // Make the context not bottom-left oriented
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, imageFrame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Fill the background in black
    CGContextSetGrayFillColor(context, 0.0, 1);
    CGContextFillRect(context, frameRect);


    // Fill the area behind the PDF white
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextFillRect(context, imageFrame);

    // Scale and fit the pdf to fit into our frame.
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, imageFrame, 0, true);
    CGContextConcatCTM(context, pdfTransform);

    @try {
        CGContextDrawPDFPage(context, page);
    }
    @catch (NSException *exception) {
        // Fail gracefully,
        // this has been known to crash in the PDF font rendering in iOS betas.

        ARSyncLog(@"An exception was raised in rendering the PDF thumbnail for %@. \n %@", _source, exception);
        [self cancelRendering];
        CFRelease(pdfDocument);
        return;
    }

    // Create the new UIImage from the context
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();

    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    CFRelease(pdfDocument);

    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:[_destination stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"Error creating dictionary for destination");
        [self cancelRendering];
        return;
    }

    // We're done
    NSData *imageData = UIImageJPEGRepresentation(thumbnailImage, 0.8f);
    [imageData writeToFile:_destination atomically:YES];

    // Disable the timeout timer.
    [self.class cancelPreviousPerformRequestsWithTarget:self];
}

- (CGRect)aspectFittedRect:(CGRect)inRect max:(CGRect)maxRect
{
    float originalAspectRatio = inRect.size.width / inRect.size.height;
    float maxAspectRatio = maxRect.size.width / maxRect.size.height;

    CGRect newRect = maxRect;
    if (originalAspectRatio > maxAspectRatio) { // scale by width
        newRect.size.height = maxRect.size.width * inRect.size.height / inRect.size.width;
        newRect.origin.y += (maxRect.size.height - newRect.size.height) / 2.0;

    } else {
        newRect.size.width = maxRect.size.height * inRect.size.width / inRect.size.height;
        newRect.origin.x += (maxRect.size.width - newRect.size.width) / 2.0;
    }

    return CGRectIntegral(newRect);
}

- (void)cancelRendering
{
    ARSyncLog(@"Timed out on %@ skipping.", _source);
    [self.class cancelPreviousPerformRequestsWithTarget:self];
    [self cancel];
}

@end

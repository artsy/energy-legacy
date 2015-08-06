//
//  UIImage+ImmediateLoading.h
//  Code taken from https://gist.github.com/259357
//


#import "UIImage+ImmediateLoading.h"


@implementation UIImage (UIImage_ImmediateLoading)

+ (UIImage *)imageImmediateLoadWithContentsOfFile:(NSString *)path
{
    return [[UIImage alloc] initImmediateLoadWithContentsOfFile:path];
}

- (UIImage *)initImmediateLoadWithContentsOfFile:(NSString *)path
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    if (!image) return nil;

    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);

    // Stack Overflow and this original gist tell us kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
    // is required for the work to stay off the main thread but we can't source this
    // Considering you can't create a bitmap context for a grayscale with those flags,
    // we'll take out chances this way

    CGBitmapInfo info = 0;
    if (colorSpace == gray) {
        // |= to stop clang from complaining. From the docs:
        // "The constants for specifying the alpha channel information
        // are declared with the CGImageAlphaInfo type but can be passed to this parameter safely."
        info |= kCGImageAlphaNone;
    } else {
        info = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little;
    }
    CGColorSpaceRelease(gray);
    CGRect rect = CGRectMake(0.f, 0.f, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       rect.size.width,
                                                       rect.size.height,
                                                       CGImageGetBitsPerComponent(imageRef),
                                                       0,
                                                       colorSpace,
                                                       info);

    CGContextDrawImage(bitmapContext, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(bitmapContext);
    UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef];
    CGImageRelease(decompressedImageRef);
    CGContextRelease(bitmapContext);

    return decompressedImage;
}

@end

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+FolioColours.h"
#import "UIImage+ImageFromColor.h"


@implementation UIImageView (ArtsySetURL)

- (void)setupWithImage:(Image *)image format:(NSString *)format
{
    NSString *path = [image imagePathWithFormatName:format];
    NSURL *url = [image imageURLWithFormatName:format];
    [self setupWithFilepath:path url:url];
}

- (void)setupWithFilepath:(NSString *)path url:(NSURL *)url
{
    if (path && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.image = [UIImage imageWithContentsOfFile:path];

    } else if (url) {
        [self ar_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.backgroundColor = [UIColor artsyBackgroundColor];

            ar_dispatch_async(^{
                if (image && path && !error) {
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                    BOOL wrote = [imageData writeToFile:path atomically:YES];

                    if (!wrote) {
                        NSLog(@"setupWithFilepath:url: Could not write downloaded image to %@", path);
                    }
                }
            });
        }];
    }
}

- (void)ar_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock
{
    BOOL isTesting = (NSClassFromString(@"XCTest") != nil);
    if (isTesting) {
        // Is it a local reference, set it
        if ([url isFileURL]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
                // If it exists, set it
                UIImage *image = [[UIImage alloc] initWithContentsOfFile:url.path];
                self.image = image;
            } else {
                // Otherwise its a local file that doesn't exist -> dark grey
                self.image = [UIImage imageFromColor:[UIColor artsyHeavyGrey]];
            }

        } else if (url.host) {
            // Is it a URL? Well, download it synchronously
            NSData *data = [NSData dataWithContentsOfURL:url];
            self.image = [UIImage imageWithData:data];

        } else {
            // If we can't do anything, make it purple
            self.image = [UIImage imageFromColor:[UIColor artsyPurple]];
        }

        if (completedBlock) completedBlock(self.image, nil, SDImageCacheTypeNone, url);
    } else {
        [self sd_setImageWithURL:url completed:completedBlock];
    }
}

@end

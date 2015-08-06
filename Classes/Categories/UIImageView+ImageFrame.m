#import "UIImageView+ImageFrame.h"


@implementation UIImageView (ImageFrame)

- (CGRect)frameForImage
{
    CGFloat imageRatio = self.image.size.width / self.image.size.height;
    CGFloat viewRatio = self.frame.size.width / self.frame.size.height;

    if (imageRatio < viewRatio) {
        CGFloat scale = self.frame.size.height / self.image.size.height;
        CGFloat width = scale * self.image.size.width;
        CGFloat topLeftX = (self.frame.size.width - width) * 0.5;

        return CGRectMake(topLeftX, 0, width, self.frame.size.height);

    } else {
        CGFloat scale = self.frame.size.width / self.image.size.width;
        CGFloat height = scale * self.image.size.height;
        CGFloat topLeftY = (self.frame.size.height - height) * 0.5;

        return CGRectMake(0, topLeftY, self.frame.size.width, height);
    }
}

@end

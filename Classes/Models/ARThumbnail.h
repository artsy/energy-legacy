#import <Foundation/Foundation.h>


@interface ARThumbnail : NSObject

+ (ARThumbnail *)thumbnailWithImage:(Image *)image format:(NSString *)format;

@property (nonatomic, strong) Image *image;
@property (nonatomic, strong) NSString *format;

@end

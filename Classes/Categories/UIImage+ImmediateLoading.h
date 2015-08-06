//
//  UIImage+ImmediateLoading.h
//  Code taken from https://gist.github.com/259357
//

#import <Foundation/Foundation.h>


@interface UIImage (UIImage_ImmediateLoading)

- (UIImage *)initImmediateLoadWithContentsOfFile:(NSString *)path;

+ (UIImage *)imageImmediateLoadWithContentsOfFile:(NSString *)path;

@end

#import "_LocalImage.h"

// This class means we can use local filepaths for images in the grid without
// having to stub a bunch of functions


@interface LocalImage : _LocalImage

@property (nonatomic, copy, readwrite) NSString *imageFilePath;

@end

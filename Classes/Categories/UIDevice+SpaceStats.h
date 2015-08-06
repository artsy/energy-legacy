#import <UIKit/UIKit.h>


@interface UIDevice (SpaceStats)

+ (NSString *)humanReadableStringFromBytes:(double)bytes;

+ (double)bytesOfDeviceFreeSpace;

+ (double)bytesOfTotalSpaceOnDevice;

+ (unsigned long long)bytesUsedInApplicationDocumentsDirectory;

+ (unsigned long long)sizeForFolderAtPath:(NSString *)folderPath;

+ (BOOL)hasTotalBytesFree:(double)bytes;
@end

#import "UIDevice+SpaceStats.h"
#include <sys/mount.h>


@implementation UIDevice (SpaceStats)

+ (NSString *)humanReadableStringFromBytes:(double)bytes
{
    if (bytes < 0) {
        bytes *= -1;
    }

    static const char units[] = {'\0', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'};
    static int maxUnits = sizeof units - 1;

    int multiplier = 1000;
    int exponent = 0;

    while (bytes >= multiplier && exponent < maxUnits) {
        bytes /= multiplier;
        exponent++;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    // Beware of reusing this format string. -[NSString stringWithFormat] ignores \0, *printf does not.
    return [NSString stringWithFormat:@"%@ %cB", [formatter stringFromNumber:@(bytes)], units[exponent]];
}

+ (double)bytesOfDeviceFreeSpace
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    struct statfs tStats;
    statfs([[paths lastObject] UTF8String], &tStats);
    return tStats.f_bavail * tStats.f_bsize;
}

+ (double)bytesOfTotalSpaceOnDevice
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    struct statfs tStats;
    statfs([[paths lastObject] UTF8String], &tStats);
    return tStats.f_blocks * tStats.f_bsize;
}

+ (unsigned long long)bytesUsedInApplicationDocumentsDirectory
{
    NSString *folder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [self sizeForFolderAtPath:folder];
}

+ (unsigned long long)sizeForFolderAtPath:(NSString *)folderPath
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    double fileSize = 0;

    for (NSString *fileName in filesArray) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }

    return fileSize;
}

+ (BOOL)hasTotalBytesFree:(double)bytes
{
    return [UIDevice bytesOfDeviceFreeSpace] > bytes;
}

@end

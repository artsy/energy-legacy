
#import "NSFileManager+FolderSize.h"


@implementation NSFileManager (FolderSize)

- (unsigned long long)sizeOfFoldersContents:(NSString *)folderPath
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    unsigned long long fileSize = 0;

    for (NSString *fileName in filesArray) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }

    return fileSize;
}

@end

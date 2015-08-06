#import <Foundation/Foundation.h>


@interface NSFileManager (FolderSize)

- (unsigned long long int)sizeOfFoldersContents:(NSString *)folderPath;

@end

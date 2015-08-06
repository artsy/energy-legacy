#import "NSFileManager+SkipBackup.h"
#include <sys/xattr.h>


@implementation NSFileManager (SkipBackup)

// Based on http://www.ios-dev-blog.com/how-to-add-skip-backup-on-icloud-attribute-to-file/

- (void)backgroundAddSkipBackupAttributeToDirectoryAtPath:(NSString *)path
{
    ar_dispatch_async(^{
        [self addSkipBackupAttributeToDirectoryAtPath:path];
    });
}

- (void)addSkipBackupAttributeToDirectoryAtPath:(NSString *)path
{
    [self addSkipBackupAttributeToFileAtPath:path];

    NSArray *itemNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *itemName in itemNames) {
        NSString *filePath = [path stringByAppendingPathComponent:itemName];
        BOOL isDirectory = NO;
        BOOL itemExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
        if (itemExists) {
            if (isDirectory) {
                [self addSkipBackupAttributeToDirectoryAtPath:filePath];
            } else {
                [self addSkipBackupAttributeToFileAtPath:filePath];
            }
        }
    }
}

- (void)addSkipBackupAttributeToFileAtPath:(NSString *)filePath
{
    NSError *error = nil;
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    BOOL success = [URL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
}

- (BOOL)hasSkipBackupAttributeAtPath:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        const char *filePathChar = [filePath fileSystemRepresentation];

        const char *attrName = "com.apple.MobileBackup";
        u_int8_t attrValue;

        getxattr(filePathChar, attrName, &attrValue, sizeof(attrValue), 0, 0);

        return attrValue == 1;
    } else {
        NSLog(@"File does not exist at path : %@ for adding skip backup to", filePath);
        return NO;
    }
}

@end

#import <Foundation/Foundation.h>


@interface NSFileManager (SkipBackup)

/// Performs adding the Skip attibute to all the contents of a directory on a background thread
- (void)backgroundAddSkipBackupAttributeToDirectoryAtPath:(NSString *)path;

/// Ensure that all the contents of a folder have the iCloud "do not backup" set
- (void)addSkipBackupAttributeToDirectoryAtPath:(NSString *)path;

/// Ensure a single file does not have iClouds "do not backup" set
- (void)addSkipBackupAttributeToFileAtPath:(NSString *)filePath;

/// Confirm that a folder does not have backup attributes set
- (BOOL)hasSkipBackupAttributeAtPath:(NSString *)filePath;

@end

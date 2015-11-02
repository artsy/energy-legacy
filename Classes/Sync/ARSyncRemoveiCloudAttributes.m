#import "ARSyncRemoveiCloudAttributes.h"
#import "NSFileManager+SkipBackup.h"
#import "ARFileUtils.h"


@interface ARSyncRemoveiCloudAttributes ()
@property (nonatomic, strong, readwrite) NSFileManager *fileManager;
@end


@implementation ARSyncRemoveiCloudAttributes

- (void)syncDidFinish:(ARSync *)sync
{
    NSString *userDocuments = [ARFileUtils userDocumentsDirectoryPath];
    [self.fileManager backgroundAddSkipBackupAttributeToDirectoryAtPath:userDocuments];
}

- (NSFileManager *)fileManager
{
    return _fileManager ?: [NSFileManager defaultManager];
}

@end

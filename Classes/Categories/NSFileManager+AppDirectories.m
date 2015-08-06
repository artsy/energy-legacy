#import "NSFileManager+AppDirectories.h"


@implementation NSFileManager (AppDirectories)

- (NSString *)applicationDocumentsDirectoryPath
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [url path];
}

- (NSString *)applicationCachesDirectoryPath
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    return [url path];
}

@end

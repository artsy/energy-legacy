#import "NSFileManager+SimpleDeletion.h"


@implementation NSFileManager (SimpleDeletion)

- (void)deleteFileAtPath:(NSString *)path
{
    NSError *error = nil;
    if ([self fileExistsAtPath:path]) {
        if (![self removeItemAtPath:path error:&error] && error) {
            ARSyncLog(@"Error removing file at %@ - %@", path, error.localizedDescription);
        }

    } else {
        ARSyncLog(@"No file found for deletion at %@", path);
    }
}

@end

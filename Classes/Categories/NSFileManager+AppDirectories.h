#import <Foundation/Foundation.h>


@interface NSFileManager (AppDirectories)
- (NSString *)applicationDocumentsDirectoryPath;

- (NSString *)applicationCachesDirectoryPath;
@end

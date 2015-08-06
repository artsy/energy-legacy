#import <Foundation/Foundation.h>


@interface ARFileUtils : NSObject

+ (NSString *)applicationCachesDirectoryPath;

+ (NSString *)userDocumentsDirectoryPath;

+ (NSString *)userLibraryDirectoryPath;

+ (void)removeContentsOfFolder:(NSString *)folderPath;

+ (NSString *)filePathWithFolder:(NSString *)folderName
                        filename:(NSString *)imageName
                       extension:(NSString *)extension;

+ (NSString *)filePathWithFolder:(NSString *)folderName
                documentFileName:(NSString *)fileName;

+ (NSString *)humanReadableStringFromBytes:(double)bytes;

@end

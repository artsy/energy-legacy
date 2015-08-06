#import "ARFileUtils.h"

static NSString *DocumentsDirectory;
static NSString *LibraryDirectory;
static NSString *CachesDirectory;


@interface ARFileUtils ()
@end


@implementation ARFileUtils

#pragma mark -
#pragma mark Directory Paths

+ (void)initialize
{
    if (self == [ARFileUtils class]) {
        [self initializeDirectoryPathVaribles];
    }
}

+ (void)initializeDirectoryPathVaribles
{
    NSArray *cachesDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                                        inDomains:NSUserDomainMask];
    CachesDirectory = [[cachesDirectories lastObject] relativePath];

    NSArray *libraryDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory
                                                                         inDomains:NSUserDomainMask];
    LibraryDirectory = [[libraryDirectories lastObject] relativePath];

    NSArray *documentsDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                           inDomains:NSUserDomainMask];
    DocumentsDirectory = [[documentsDirectories lastObject] relativePath];
}

+ (NSString *)applicationCachesDirectoryPath
{
    return CachesDirectory;
}

+ (NSString *)userLibraryDirectoryPath
{
    return LibraryDirectory;
}

+ (NSString *)userDocumentsDirectoryPath
{
    return DocumentsDirectory;
}

#pragma mark -
#pragma mark Actions on directories

+ (void)removeContentsOfFolder:(NSString *)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:folderPath];
    NSError *error = nil;

    for (NSString *fileName in enumerator) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];

        if (![fileManager removeItemAtPath:filePath error:&error]) {
            NSLog(@"Error removing file %@ : %@", fileName, error);
        }
    }
}

+ (NSString *)filePathWithFolder:(NSString *)folderName
                        filename:(NSString *)imageName
                       extension:(NSString *)extension
{
    NSString *documentsDirectory = [ARFileUtils userDocumentsDirectoryPath];

    NSString *directory = [documentsDirectory stringByAppendingPathComponent:folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error) {
            NSLog(@"Error creating directory at path %@", folderName);
            NSLog(@"%@", [error userInfo]);
        }
    }
    NSString *path = [[NSString alloc] initWithFormat:@"%@/%@.%@", directory, imageName, extension];
    return path;
}

+ (NSString *)filePathWithFolder:(NSString *)folderName
                documentFileName:(NSString *)fileName
{
    NSString *documentsDirectory = [ARFileUtils userDocumentsDirectoryPath];

    NSString *directory = [documentsDirectory stringByAppendingPathComponent:folderName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error) {
            NSLog(@"Error creating directory at path %@", folderName);
            NSLog(@"%@", [error userInfo]);
        }
    }

    NSString *path = [directory stringByAppendingPathComponent:fileName];
    NSAssert3(path, @"Failed to construct a path for folder %@, filename %@, extension %@", folderName, imageName, extension);
    return path;
}

+ (NSString *)humanReadableStringFromBytes:(double)bytes
{
    static const char units[] = {'\0', 'k', 'm', 'g', 't', 'p', 'e', 'z', 'y'};
    static int maxUnits = sizeof units - 1;

    int multiplier = 1000;
    int exponent = 0;

    while (bytes >= multiplier && exponent < maxUnits) {
        bytes /= multiplier;
        exponent++;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if (exponent == 1) {
        [formatter setMaximumFractionDigits:0];
    } else {
        [formatter setMaximumFractionDigits:2];
    }

    // Beware of reusing this format string. -[NSString stringWithFormat] ignores \0, *printf does not.
    return [NSString stringWithFormat:@"%@ %cb", [formatter stringFromNumber:@(bytes)], units[exponent]];
}

@end

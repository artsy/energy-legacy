#import "AFHTTPRequestOperation.h"

/// The ARFileDownloadOperation is a memory safe file downloader
/// that uses NSOutputStream to skip putting large downloads into RAM.


@interface AFHTTPRequestOperation (ARFileDownload)

+ (instancetype)fileDownloadFromURL:(NSURL *)url toLocalPath:(NSString *)localPath;
+ (instancetype)authenticatedFileDownloadFromURL:(NSURL *)url toLocalPath:(NSString *)localPath;

@end

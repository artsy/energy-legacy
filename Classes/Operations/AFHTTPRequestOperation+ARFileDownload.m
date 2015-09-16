@import AFNetworking;

#import "AFHTTPRequestOperation+ARFileDownload.h"
#import "ARRouter.h"


@implementation AFHTTPRequestOperation (ARFileDownload)

+ (instancetype)authenticatedFileDownloadFromURL:(NSURL *)url toLocalPath:(NSString *)localPath
{
    return [self fileDownloadFromURLRequest:[ARRouter requestForURL:url] toLocalPath:localPath];
}

+ (instancetype)fileDownloadFromURL:(NSURL *)url toLocalPath:(NSString *)localPath
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    return [self fileDownloadFromURLRequest:request toLocalPath:localPath];
}

+ (instancetype)fileDownloadFromURLRequest:(NSURLRequest *)request toLocalPath:(NSString *)localPath
{
    AFHTTPRequestOperation *this = [[self alloc] initWithRequest:request];
    this.outputStream = [NSOutputStream outputStreamToFileAtPath:localPath append:NO];
    return this;
}

@end

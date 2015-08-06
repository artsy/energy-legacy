static BOOL ARDispatchIsRunningInTests = NO;

void ar_dispatch_after(NSTimeInterval time, dispatch_block_t block)
{
    ar_dispatch_after_on_queue(time, dispatch_get_main_queue(), block);
}

void ar_dispatch_after_on_queue(NSTimeInterval time, dispatch_queue_t queue, dispatch_block_t block)
{
    if (ARDispatchIsRunningInTests) {
        block();
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), queue, block);
    }
}

void ar_dispatch_async(dispatch_block_t block)
{
    ar_dispatch_on_queue(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void ar_dispatch_main_queue(dispatch_block_t block)
{
    ar_dispatch_on_queue(dispatch_get_main_queue(), block);
}

void ar_dispatch_on_queue(dispatch_queue_t queue, dispatch_block_t block)
{
    if (ARDispatchIsRunningInTests) {
        if ([NSThread isMainThread]) {
            block();
        } else {
            dispatch_sync(queue, block);
        }
    } else {
        dispatch_async(queue, block);
    }
}

/// Internal class for setting up static BOOL


@interface ARDispatchManager : NSObject
@end


@implementation ARDispatchManager

+ (void)load
{
    ARDispatchIsRunningInTests = (NSClassFromString(@"XCTest") != nil);
}

@end

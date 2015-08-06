/// Async in App Code, sync in Test Code, waits for a time then runs the block on the main queue
extern void ar_dispatch_after(NSTimeInterval time, dispatch_block_t block);

/// Async in App Code, sync in Test Code, waits for a time then runs the block on your own queue
extern void ar_dispatch_after_on_queue(NSTimeInterval time, dispatch_queue_t queue, dispatch_block_t block);

/// Async in App Code, sync in Test Code, runs a block on a default queue on another thread
extern void ar_dispatch_async(dispatch_block_t block);

/// Async in App Code, sync in Test Code, runs a block on the main thread
extern void ar_dispatch_main_queue(dispatch_block_t block);

/// Async in App Code, sync in Test Code, runs block on a queue
extern void ar_dispatch_on_queue(dispatch_queue_t queue, dispatch_block_t block);

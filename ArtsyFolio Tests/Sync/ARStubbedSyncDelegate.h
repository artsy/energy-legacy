#import <Foundation/Foundation.h>
#import "ARSync.h"


@interface ARStubbedSyncDelegate : NSObject <ARSyncDelegate>

@property (nonatomic, copy) void (^onSyncCompletion)(void);

@end

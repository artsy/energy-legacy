#import "ARBlockRunner.h"


@implementation ARBlockRunner

- (void)runBlock
{
    NSParameterAssert(_block);
    self.block();
}

@end

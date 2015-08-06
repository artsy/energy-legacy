#import "ARSwitchView.h"


@implementation ARSwitchView

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    NSLog(@"This method should be subclassed %@", self);
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (NSInteger)selectedIndex
{
    NSLog(@"This method should be subclassed %@", self);
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return NSNotFound;
}

@end

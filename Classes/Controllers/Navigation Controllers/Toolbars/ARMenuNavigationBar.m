#import "ARMenuNavigationBar.h"
#import "ARTableViewCell.h"


@implementation ARMenuNavigationBar

- (CGSize)sizeThatFits:(CGSize)size
{
    size.height = ARTableViewCellSettingsHeight;
    size.width = self.superview.bounds.size.width;
    return size;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"White.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end

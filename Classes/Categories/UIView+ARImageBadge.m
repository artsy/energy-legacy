#import "UIView+ARImageBadge.h"
#import <objc/runtime.h>

@implementation ARImageBadge : UIImageView

- (instancetype)initWithImage:(UIImage *)image position:(ARImageBadgePosition)position offset:(CGFloat)offset
{
    if(self = [super initWithImage:image]) {
        [self setPosition:position offset:offset];
    }
    
    return self;
}

- (void)setSize:(CGFloat)height width:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
}

- (void)setPosition:(ARImageBadgePosition)position offset:(NSInteger)offset
{
    CGPoint badgeOrigin;
    CGRect superViewFrame = self.superview.frame;
    
    switch (position) {
        case TopLeft:
            badgeOrigin = CGPointMake(0 - offset, 0 - offset);
            break;
            
        case TopRight:
            badgeOrigin = CGPointMake(superViewFrame.size.width/2 + offset, - offset);
            break;
            
        case BottomLeft:
            badgeOrigin = CGPointMake(- offset, superViewFrame.size.height/2 + offset);
            break;
            
        case BottomRight:
            badgeOrigin = CGPointMake(superViewFrame.size.width/2 + offset, superViewFrame.size.height/2 + offset);
            break;
            
        default:
            break;
    }
    
    self.frame = CGRectMake(badgeOrigin.x, badgeOrigin.y, self.frame.size.width, self.frame.size.width);
}

@end

static const char *kARImageBadgePropertyKey = "kARImageBadgePropertyKey";

@implementation UIView (ARImageBadge)

- (void)setBadge:(ARImageBadge *)badge
{
    objc_setAssociatedObject(self, kARImageBadgePropertyKey, badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ARImageBadge *)badge
{
    ARImageBadge *badge = objc_getAssociatedObject(self, kARImageBadgePropertyKey);
    return badge;
}

- (void)addBadgeWithImage:(UIImage *)image position:(ARImageBadgePosition)position offset:(CGFloat)offset
{
    ARImageBadge *badge = [[ARImageBadge alloc] initWithImage:image];
    
    self.badge = badge;
    [self addSubview:badge];
    [self.badge setPosition:position offset:offset];
}

- (void)addBadgeWithImage:(UIImage *)image position:(ARImageBadgePosition)position
{
    [self addBadgeWithImage:image position:position offset:0];
}

@end

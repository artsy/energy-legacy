#import <Foundation/Foundation.h>

typedef void (^completionBlock)(void);


@interface ARBlockRunner : NSObject

@property (nonatomic, copy) completionBlock block;
- (void)runBlock;

@end

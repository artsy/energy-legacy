#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AvailabilityFinishedCallback)(BOOL success);
typedef void (^AvailabilityChoiceCallback)(ARArtworkAvailability newAvailability, AvailabilityFinishedCallback finished);


@interface ARPresentAvailabilityChoiceViewController : UITableViewController

@property (nonatomic, assign) ARArtworkAvailability currentAvailability;
@property (nonatomic, strong) AvailabilityChoiceCallback callback;

@end

NS_ASSUME_NONNULL_END

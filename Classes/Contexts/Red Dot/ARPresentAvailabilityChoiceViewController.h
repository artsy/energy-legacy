#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AvailabilityFinishedCallback)(BOOL success);
typedef void (^AvailabilityChoiceCallback)(ARArtworkAvailability newAvailability, AvailabilityFinishedCallback finished);

/// Shows a list of states that an artwork or edition set could be
/// and remotely calls Gravity to update it
@interface ARPresentAvailabilityChoiceViewController : UITableViewController

/// What does it start on?
@property (nonatomic, assign) ARArtworkAvailability currentAvailability;

/// When a selection was made, this gets called. It calls back
/// with the new selected availabilty and expects this function to also
/// run the `finished` arg which lets it do some UI feedback correctly
@property (nonatomic, strong) AvailabilityChoiceCallback callback;

@end

NS_ASSUME_NONNULL_END

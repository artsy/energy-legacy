NS_ENUM(NSInteger, ARModalAlertViewControllerStatus){
    ARModalAlertOK,
    ARModalAlertCancel};

@protocol ARModalAlertViewControllerDelegate <NSObject>
- (void)modalViewController:(UIViewController *)controller didReturnStatus:(enum ARModalAlertViewControllerStatus)status;
@end

typedef void (^completionBlock)(enum ARModalAlertViewControllerStatus);


@interface ARAlertViewController : UIViewController {
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *saveButton;
    completionBlock completion;
}

@property (copy, nonatomic) NSString *alertText;
@property (copy, nonatomic) NSString *cancelTitle;
@property (copy, nonatomic) NSString *okTitle;

- (instancetype)initWithCompletionBlock:(void (^)(enum ARModalAlertViewControllerStatus))completionBlock;
@end

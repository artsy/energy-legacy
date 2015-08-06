@class ARSwitchView;

@protocol ARSwitchViewDelegate <NSObject>

@required
- (void)switchView:(ARSwitchView *)switchView didSelectIndex:(NSInteger)index animated:(BOOL)animated;
@end


@interface ARSwitchView : UIView

@property (strong) IBOutlet NSObject<ARSwitchViewDelegate> *delegate;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *enabledStates;

- (NSInteger)selectedIndex;

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
@end

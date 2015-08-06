#import "UIBarButtonItem+toolbarHelpers.h"

SpecBegin(UIBarButtonItemToolBarHelpers);

describe(@"represtened button", ^{
    it(@"returns nil if the button item doesn't have a button", ^{
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"asdas" style:UIBarButtonItemStyleBordered target:nil action:nil];
        expect(item.representedButton).to.beFalsy();
    });
    
    it(@"returns a button if there is one", ^{
        UIButton *button = [[UIButton alloc] init];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        expect(item.representedButton).to.equal(button);
    });
});

describe(@"toolbarImageButtonWithName:", ^{
    it(@"returns a UIBarButtonItem with a button", ^{
        UIBarButtonItem *item = [UIBarButtonItem toolbarImageButtonWithName:@"name" withTarget:nil andSelector:nil];
        expect(item.customView).to.beKindOf(UIButton.class);
    });
    
    it(@"generates a toolbar with an image", ^{
        UIBarButtonItem *item = [UIBarButtonItem toolbarImageButtonWithName:@"Add To Album" withTarget:nil andSelector:nil];
        expect(item.representedButton.imageView.image).to.beTruthy();
    });

    it(@"sets the right targer & action", ^{
        NSObject *object = [[NSObject alloc] init];
        SEL selector = @selector(init);
        
        UIBarButtonItem *item = [UIBarButtonItem toolbarImageButtonWithName:@"Add To Album" withTarget:object andSelector:selector];
        
        expect([item.representedButton actionsForTarget:object forControlEvent:UIControlEventTouchUpInside]).to.contain(NSStringFromSelector(selector));
    });
        
    it(@"sets an accessory label", ^{
        NSString *title = @"Add To Album";
        UIBarButtonItem *item = [UIBarButtonItem toolbarImageButtonWithName:title withTarget:nil andSelector:nil];
        expect(item.representedButton.accessibilityLabel).to.equal(title);
    });
});

SpecEnd;

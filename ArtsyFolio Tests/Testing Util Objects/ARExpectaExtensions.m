#import "ARNavigationController+Testing.h"
#import "ARTheme.h"

void _itTestsWithDevicesAndColorStateRecording(id self, int lineNumber, const char *fileName, BOOL record, NSString *name, id (^block)())
{
    __block ARNavigationController *controller;

    void (^snapshot)(id, NSString *) = ^void(id sut, NSString *suffix) {
        
        id actual = ([sut isKindOfClass:UIViewController.class] && controller) ? controller.view : sut;
        
        EXPExpect *expectation = _EXP_expect(self, lineNumber, fileName, ^id{ return EXPObjectify((actual)); });
        
        if (record) {
            expectation.to.recordSnapshotNamed([name stringByAppendingString:suffix]);
        } else {
            expectation.to.haveValidSnapshotNamed([name stringByAppendingString:suffix]);
        }
    };

    it([name stringByAppendingString:@" as ipad"], ^{
        
        @try {
            [ARTestContext useContext: ARTestContextDeviceTypePad :^{
                id sut = block();
                [ARTheme setupWithWhiteFolio:NO];
                
                if ([sut isKindOfClass:UIViewController.class] && ![sut isKindOfClass:UINavigationController.class]) {
                    controller = [ARNavigationController onscreenNavigationControllerWithRootViewController:sut];
                }
                
                snapshot(sut, @" as ipad dark");
                
                sut = block();
                [ARTheme setupWithWhiteFolio:YES];
                
                if ([sut isKindOfClass:UIViewController.class] && ![sut isKindOfClass:UINavigationController.class]) {
                    controller = [ARNavigationController onscreenNavigationControllerWithRootViewController:sut];
                }
                snapshot(sut, @" as ipad light");
            }];
            
        }
        @catch (NSException *exception) {
            EXPFail(self, lineNumber, fileName, [NSString stringWithFormat:@"'%@' has crashed", [name stringByAppendingString:@" as iphone"]]);
        }
        @finally {
            [ARTestContext endContext];
        }
    });

    it([name stringByAppendingString:@" as iphone"], ^{
        
        @try {
            [ARTestContext useContext: ARTestContextDeviceTypePhone5 :^{
                
                id sut = block();
                [ARTheme setupWithWhiteFolio:NO];
                
                if ([sut isKindOfClass:UIViewController.class] && ![sut isKindOfClass:UINavigationController.class]) {
                    controller = [ARNavigationController onscreenNavigationControllerWithRootViewController:sut];
                }
                snapshot(sut, @" as iphone dark");
                
                [ARTheme setupWithWhiteFolio:YES];
                sut = block();
                
                if ([sut isKindOfClass:UIViewController.class] && ![sut isKindOfClass:UINavigationController.class]) {
                    controller = [ARNavigationController onscreenNavigationControllerWithRootViewController:sut];
                }
                snapshot(sut, @" as iphone light");
                
                [ARTheme setupWithWhiteFolio:NO];
            }];
            
        }
        @catch (NSException *exception) {
            EXPFail(self, lineNumber, fileName, [NSString stringWithFormat:@"'%@' has crashed", [name stringByAppendingString:@" as iphone"]]);
        }
        @finally {
            [ARTestContext endContext];
        }
    });
}


void _itTestsWithDevicesRecording(id self, int lineNumber, const char *fileName, BOOL record, NSString *name, id (^block)())
{
    void (^snapshot)(id, NSString *) = ^void(id sut, NSString *suffix) {
        EXPExpect *expectation = _EXP_expect(self, lineNumber, fileName, ^id{ return EXPObjectify(sut); });
        
        if (record) {
            expectation.to.recordSnapshotNamed([name stringByAppendingString:suffix]);
        } else {
            expectation.to.haveValidSnapshotNamed([name stringByAppendingString:suffix]);
        }
    };

    it([name stringByAppendingString:@" as iphone"], ^{
        
        @try {
            [ARTestContext useContext: ARTestContextDeviceTypePhone5  :^{
                id sut = block();
                snapshot(sut, @" as iphone");
            }];
        }
        @catch (NSException *exception) {
            EXPFail(self, lineNumber, fileName, [NSString stringWithFormat:@"'%@' has crashed", [name stringByAppendingString:@" as iphone"]]);
            
        }
        @finally {
            [ARTestContext endContext];
        }

    });

    it([name stringByAppendingString:@" as ipad"], ^{
        
        @try {
            [ARTestContext useContext: ARTestContextDeviceTypePad  :^{
                id sut = block();
                snapshot(sut, @" as ipad");
            }];
            
        }
        @catch (NSException *exception) {
            EXPFail(self, lineNumber, fileName, [NSString stringWithFormat:@"'%@' has crashed", [name stringByAppendingString:@" as iphone"]]);
        }
        @finally {
            [ARTestContext endContext];
        }
    });
}

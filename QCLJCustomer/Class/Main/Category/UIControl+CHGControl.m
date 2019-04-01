//
//  UIControl+CHGControl.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/12/5.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UIControl+CHGControl.h"
#import <objc/runtime.h>

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

@implementation UIControl (CHGControl)
- (NSTimeInterval)acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}


- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)FMG_ignoreEvent
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}


+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(FMG_sendAction:to:froEvent:));
    
    method_exchangeImplementations(a, b);
}

- (void)FMG_sendAction:(SEL)action to:(id)target froEvent:(UIEvent *)event
{
//    if (self.acceptEventInterval > 0) {
//        if (self.userInteractionEnabled) {
//            
//            [self FMG_sendAction:action to:target froEvent:event];
//        }
//        self.userInteractionEnabled = NO;
//        NSLog( @"%f",self.acceptEventInterval);
//        [self performSelector:@selector(setUserInteractionEnabled:) withObject:@(YES) afterDelay:self.acceptEventInterval];
////        if (self.acceptEventInterval == 0) {
////            self.acceptEventInterval = 1;
////        }
//        
////    GCD 延迟执行 self.acceptEventInterval：为延迟时间
//         __weak typeof (self) weakSelf = self;
//         dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.acceptEventInterval * NSEC_PER_SEC));
//         
//         dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//         weakSelf.userInteractionEnabled = YES;
//             
//             NSLog( @"UIControl=====-----%f",weakSelf.acceptEventInterval);
//         });
//         
//         
//        
//    } else {
//        [self FMG_sendAction:action to:target froEvent:event];
//    }
    
    if (self.acceptEventInterval > 0) {
        if (self.userInteractionEnabled) {
//            [self delaySendAction:action to:target froEvent:event];
            [self FMG_sendAction:action to:target froEvent:event];
        }
        self.userInteractionEnabled = NO;
        __weak typeof (self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.acceptEventInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.userInteractionEnabled = YES;
        });
    } else {
//        [self delaySendAction:action to:target froEvent:event];
        [self FMG_sendAction:action to:target froEvent:event];
    }
}
@end

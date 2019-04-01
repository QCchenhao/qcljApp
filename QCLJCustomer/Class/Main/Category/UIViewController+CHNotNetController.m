//
//  UIViewController+CHNotNetController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/30.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UIViewController+CHNotNetController.h"
#import "Comment.h"
#import "CHNotInternetView.h"

#import "MemberShipCardViewController.h"

#import "ServiceAddressTableTableViewController.h"//地图

//#import "QiCaiNavigationController.h"
//#import "QiCaiTabBarController.h"

#import "SetUpViewController.h"//设置
#import "MyMessageViewController.h"//我的消息
#import "MembershipCardController.h"//会员余额
//拿到屏幕的宽高
#define MYScreenW [UIScreen mainScreen].bounds.size.width
#define MYScreenH [UIScreen mainScreen].bounds.size.height



@interface UIViewController ()<CHNotInternetViewDelegate>

@end
@implementation UIViewController (CHNotNetController)

- (void)showNotInternetViewToAbnormalState:(AbnormalState )AbnormalState message1:(NSString *)message1 message2:(NSString *)message2
{
    NSInteger tag = 0;
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[CHNotInternetView class]]) {
            tag++;
        }
    }
    if(tag>0)
        return;
    CGFloat YY = 0;
    if([self isKindOfClass:[MemberShipCardViewController class]]){
        YY = 150;

    }
    if([self isKindOfClass:[ServiceAddressTableTableViewController class]]){
        YY = -40;
        
    }
    CHNotInternetView  * view = [[CHNotInternetView alloc] initWithFrame:CGRectMake(0, YY, MYScreenW,MYScreenH - YY)];
    view.delegate = self;
    
    switch (AbnormalState) {
        case AbnormalStateNoDataLookup:
            view.imageStr = @"Home_order_serchPlace";
            //    view.CHtitle = @"加载失败，网络不给力";
            if (message1) {
                view.message1 = message1;
            }
            //    view.message2 = @"message2";
            view.btnStr = @"立即预约";
            break;
        case AbnormalStateNoDataNo:
            view.imageStr = @"home_placreNo";
            //    view.CHtitle = @"加载失败，网络不给力";
            if (message1) {
                view.message1 = message1;
            }
            if (message1) {
                view.message2 = message2;
            }
//            view.btnStr = @"重新加载";
            break;
        case AbnormalStateNoNetwork:
            view.imageStr = @"home_placreNo";
                view.CHtitle = @"加载失败，网络不给力";
            view.message1 = @"请点击按钮重新加载";
            //    view.message2 = @"message2";
            view.btnStr = @"重新加载";
            break;
        case AbnormalStateNoDataNoAddress:
            view.imageStr = @"me_address_NoData";
            view.message3 = message1;
//            view.message1 = message1;
            //    view.message2 = message1;
//            view.btnStr = @"重新加载";
            break;
        default:
            break;
    }
//    view.imageStr = @"Home_order_serchPlace";
////    view.CHtitle = @"加载失败，网络不给力";
//    view.message1 = @"请点击按钮重新加载";
////    view.message2 = @"message2";
//    view.btnStr = @"重新加载";
    [self.view addSubview:view];
}
- (void)hiddenNotInternetView
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[CHNotInternetView class]]) {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - TCNotInternetViewDelegate
- (void)reloadNetworkRequest:(UIButton *)sender{
    if ([self respondsToSelector:@selector(requestDataWithStart:)]) {
        [self performSelector:@selector(requestDataWithStart:)withObject:sender];
    }
}

- (void)viewWillLayoutSubviews{

    if (iOS10) {
        
        if ([self isKindOfClass:[SetUpViewController class]]
            || [self isKindOfClass:[MyMessageViewController class]]) {
            
            VDLog(@"QiCaiNavigationController");
            if (self.view.subviews.count > 0) {
                [self.view.subviews objectAtIndex:0].y +=  kDownHeight;
            }
        }else if ([self isKindOfClass:[MembershipCardController class]]){
            if (self.view.subviews.count > 0) {
                [self.view.subviews objectAtIndex:0].y +=  kDownHeight;
            }
            
        }
        
    }

}
@end

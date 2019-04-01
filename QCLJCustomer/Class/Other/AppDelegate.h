//
//  AppDelegate.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
///**
// 是否登录
// */
//@property (assign, nonatomic) BOOL isLogin;

/**
 网络状态
 */
@property (nonatomic, assign) BOOL isNetworkState;

/**
 登录倒计时
 */
@property (nonatomic, assign) int timeLogin;

//- (void)wechatLoginByRequestForUserInfo;
@end


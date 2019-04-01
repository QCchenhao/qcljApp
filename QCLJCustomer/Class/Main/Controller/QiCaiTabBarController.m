//
//  QiCaiTabBarController.m
//  七彩乐居
//
//  Created by 李大娟 on 16/2/29.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QiCaiTabBarController.h"
#import "Comment.h"
#import "QiCaiNavigationController.h"

#import "HomeViewController.h"
#import "OrderViewController.h"
#import "MemberShipCardViewController.h"
#import "MeViewController.h"

@interface QiCaiTabBarController ()

@end

@implementation QiCaiTabBarController

// 设置tabBarItem的主题
+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    
    // titlePositionAdjustment NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = QiCaiDetailTitle10Font;
    attrs[NSForegroundColorAttributeName] = QiCaiDeepColor;

    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [self addChildVC:homeVC title:@"首页" imageName:@"Main_navigationBar_home_off" selIamgeName:@"Main_navigationBar_home_on"];
   
    OrderViewController *onLineVC = [[OrderViewController alloc]init];
    onLineVC.orderSelectedIndex = self.orderSelectedIndex;
    [self addChildVC:onLineVC title:@"订单" imageName:@"Main_navigationBar_order_off" selIamgeName:@"Main_navigationBar_order_on"];
 
    MemberShipCardViewController *memberCardVC = [[MemberShipCardViewController alloc]init];
    [self addChildVC:memberCardVC title:@"会员卡" imageName:@"Main_navigationBar_pay_off" selIamgeName:@"Main_navigationBar_pay_on"];
    
    MeViewController *meVC  = [[MeViewController alloc]init];
    [self addChildVC:meVC title:@"我的" imageName:@"Main_navigationBar_member_off" selIamgeName:@"Main_navigationBar_member_on"];
}

//用来创建控制器
-(void)addChildVC:(UIViewController *)VC title:(NSString *)title imageName:(NSString *)imageName selIamgeName:(NSString *)selImageName
{
    VC.title = title;
    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:QiCaiNavBackGroundColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    //
//    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MYColor(219, 0, 108), NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
   
    // ios7之后系统会自动渲染图片，对tabBarItem的selected图片进行处理
    UIImage *selImage = [UIImage imageNamed:selImageName];
    
    // 不让系统处理图片变蓝
    
    if (iOS7) {
        
        selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    [VC.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [VC.tabBarItem setSelectedImage:selImage];
    
    QiCaiNavigationController *nav = [[QiCaiNavigationController alloc]initWithRootViewController:VC];

    // 添加到tabBarController
    [self addChildViewController:nav];

    
}

-(void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 40;
    tabFrame.origin.y = self.view.frame.size.height - 40;
    self.tabBar.frame = tabFrame;
}
@end

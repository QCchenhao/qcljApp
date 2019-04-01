
//
//  QiCaiNavigationController.m
//  七彩乐居
//
//  Created by 李大娟 on 16/2/29.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QiCaiNavigationController.h"
#import "Comment.h"

@interface QiCaiNavigationController ()

@end

@implementation QiCaiNavigationController

+(void)initialize
{
    [self setupNavigationBar];
    
    [self setupBarBtnItem];
    
}

+(void)setupNavigationBar
{
    UINavigationBar *navBar = [UINavigationBar appearance];

//    navBar.backgroundColor = QiCaiNavBackGroundColor;
    // 背景
//    if (!iOS7) {
//        
//        [navBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
//    }
    
    // title
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrDict[NSFontAttributeName] = QiCaiNavTitle14Font;

    // 字典只能放对象
    [navBar setBarTintColor: MYColor(218, 0, 107)];
    
    [navBar setBackgroundColor:MYColor(218, 0, 107)];
//    navBar.alpha = 1;
    
//    [navBar setBarTintColor:QiCaiNavBackGroundColor];
    
    [navBar setTitleTextAttributes:attrDict];
    
    navBar.centerX = NavigationBarHeight / 2;
    
//    navBar.tintColor = [UIColor whiteColor];
//    navBar.barStyle = UIBarStyleBlackOpaque;
    
//    //设置导航栏背景图片 nav_backgroundImage
//    [navBar setBackgroundImage:[UIImage imageNamed:] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
//       [navBar setBackgroundImage:[UIImage imageWithName:@"home_btn_normal"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
//    [self.navigationController navigationItem];
//    CGFloat navBarHeight = 45.0f;
//    CGRect frame = CGRectMake(0.0f, 20.0f, 320.0f, navBarHeight);
//    [navBar setFrame:frame];

    
}
+(void)setupBarBtnItem
{
    UIBarButtonItem *barBtnItem = [UIBarButtonItem appearance];
    
    // nor
    NSMutableDictionary *norAttrDict = [NSMutableDictionary dictionary];
    norAttrDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    norAttrDict[NSFontAttributeName] = QiCaiDetailTitle12Font;
    [barBtnItem setTitleTextAttributes:norAttrDict forState:UIControlStateNormal];

}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        // 默认每个push进来的控制器左右都有返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"Main_public_left" higImageName:@"Main_public_left" action:@selector(back) target:self];
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}
@end

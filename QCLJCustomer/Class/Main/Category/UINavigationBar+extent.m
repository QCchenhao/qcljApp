
//
//  UINavigationItem+extent.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/11.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//instancetype

#import "UINavigationBar+extent.h"

#import "Comment.h"

#import "MyButton.h"
#import "QiCaiNavigationController.h"

@implementation UINavigationBar (extent)
+ (void)addNav{
    
}
/**
 myNavBar 左图中文
 */
+(UINavigationBar * )addMyNavBarWithCenterTitle:(NSString *)centerTitle addTarget:(nullable id)target action:(SEL)action contentView:(UIView *)view{
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight)];
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"dsd"];
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //action：@selector:设置按钮的点击事件
    //创建一个左边按钮
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Main_public_left"] style:UIBarButtonItemStyleBordered target:target action:action];
    
    if (iOS7) {
        
        leftButton.image = [leftButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    
//    //创建一个右边按钮
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightButton)];
    
    //设置导航栏的内容
    [navItem setTitle:centerTitle];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
//    [navItem setRightBarButtonItem:rightButton];
    
    //调整按钮和标题的上下位置
    [navBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    [leftButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    
    //    //将标题栏中的内容全部添加到主视图当中
    //    [self.navigationController.navigationBar addSubview:navBar];
    //将标题栏中的内容全部添加到主视图当中
    [view addSubview:navBar];
//    [[view superview] bringSubviewToFront:navBar];
//    [view insertSubview:navBar atIndex:1];
//    bringSubviewToFront
    
    
    
    return navBar;
}


/**
 myNavBar 左图中文右文
 */
+(UINavigationBar *)addMyNavBarWithCenterTitle:(NSString *)centerTitle addLeftTarget:(nullable id)LeftTarget leftAction:(SEL)leftAction rightTitle:(NSString *)rightTitle addrightTarget:(nullable id)rightTarget rightAction:(SEL)rightAction contentView:(UIView *)view
{
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight)];
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //action：@selector:设置按钮的点击事件
    //创建一个左边按钮
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Main_public_left"] style:UIBarButtonItemStyleBordered target:LeftTarget action:leftAction];
    
    if (iOS7) {
        
        leftButton.image = [leftButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStyleDone target:rightTarget action:rightAction];
    if (iOS7) {
        
        rightButton.image = [rightButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    
    //设置导航栏的内容
    [navItem setTitle:centerTitle];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    
    //调整按钮和标题的上下位置
    [navBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    [leftButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    [rightButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    
    //    //将标题栏中的内容全部添加到主视图当中
    //    [self.navigationController.navigationBar addSubview:navBar];
    //将标题栏中的内容全部添加到主视图当中
    [view addSubview:navBar];
    //    [[view superview] bringSubviewToFront:navBar];
    //    [view insertSubview:navBar atIndex:1];
    //    bringSubviewToFront

    return navBar;
}
/**
 myNavBar 左图中文右图
 */
+(UINavigationBar *)addMyNavBarWithCenterTitle:(NSString *)centerTitle addLeftTarget:(NSString *)LeftTarget leftAction:(SEL)leftAction rightImageName:(NSString *)rightImageName rightImageNameLandscapeImage:(NSString *)rightImageNameLandscapeImage addrightTarget:(nullable id)rightTarget rightAction:(SEL)rightAction contentView:(UIView *)view
{
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight)];
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //action：@selector:设置按钮的点击事件
    //创建一个左边按钮
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:UIBarButtonItemStyleBordered target:self action:@selector(clickLeftButton)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Main_public_left"] style:UIBarButtonItemStyleBordered  target:LeftTarget action:leftAction];

    if (iOS7) {
        
        leftButton.image = [leftButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //创建一个右边按钮
    UIBarButtonItem *rightButton =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:rightImageName] landscapeImagePhone:[UIImage imageNamed:rightTarget] style:UIBarButtonItemStyleBordered target:rightImageNameLandscapeImage action:rightAction];
    
    if (iOS7) {
        
        rightButton.image = [rightButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //设置导航栏的内容
    [navItem setTitle:centerTitle];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    
    //调整按钮和标题的上下位置
    [navBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    [leftButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    [rightButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    
    //    //将标题栏中的内容全部添加到主视图当中
    //    [self.navigationController.navigationBar addSubview:navBar];
    //将标题栏中的内容全部添加到主视图当中
    [view addSubview:navBar];
    //    [[view superview] bringSubviewToFront:navBar];
    //    [view insertSubview:navBar atIndex:1];
    //    bringSubviewToFront
    return navBar;
}
/**
 myNavBar 左自定义中文右自定义
 */
+(UINavigationBar * _Nullable)addMyNavBarWithCenterTitle:(id _Nullable)centerTitle addLeft:(id _Nullable)left addRight:(id _Nullable)right  contentView:(UIView * _Nullable)view{
    
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    
    navBar.backgroundColor = QiCaiNavBackGroundColor;
    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    //在这个集合Item中添加标题，按钮
    
    //创建一个左边按钮
    //最重要的一步，注意initWithCustomView方法。理论上左按钮可以是任意父类是UIView的控件.
    UIBarButtonItem *leftButton;
    //创建一个右边按钮
    UIBarButtonItem *rightButton ;

    //设置导航栏的内容
    [navItem setTitle:centerTitle];

    //判断 right  是否为NSString  类型
    if ([right isKindOfClass:[UIBarButtonItem class]] ) {
        rightButton = right;
    }else {
        rightButton =  [[UIBarButtonItem alloc] initWithCustomView:right];
    }
   
    //判断  left 是否为NSString  类型
    if ([left isKindOfClass:[UIBarButtonItem class]] ) {
        leftButton = left;
    }else{
        leftButton =  [[UIBarButtonItem alloc] initWithCustomView:left];
    }
    
    if (iOS7) {
        
        leftButton.image = [leftButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    if (iOS7) {
        
        rightButton.image = [rightButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
//    [navItem setTitleView:<#(UIView * _Nullable)#>]
    //调整按钮和标题的上下位置
    [navBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    [leftButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    [rightButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    
    //    //将标题栏中的内容全部添加到主视图当中
    //    [self.navigationController.navigationBar addSubview:navBar];
    //将标题栏中的内容全部添加到主视图当中
    
    //    [[view superview] bringSubviewToFront:navBar];
    //    [view insertSubview:navBar atIndex:1];
    //    bringSubviewToFront
    
//    CGRect rec = [navBar convertRect:navBar.bounds toView:nil];
//    UIView *view1 = [[UIApplication sharedApplication].delegate window];
    
//    [view addSubview:navBar];
    view =  navBar;
//    view.backgroundColor = [UIColor yellowColor];
    
//    //logoImageView左侧与父视图左侧对齐
//    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
//    
//    //logoImageView右侧与父视图右侧对齐
//    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
//    
//    //logoImageView顶部与父视图顶部对齐
//    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
//    
//    //logoImageView高度为父视图高度一半
//    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:navBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:0.2f constant:0.0f];
//    
//    //iOS 6.0或者7.0调用addConstraints
////        [view1 addConstraints:@[leftConstraint, rightConstraint, topConstraint, heightConstraint]];
//    
//    //iOS 8.0以后设置active属性值
//    leftConstraint.active = YES;
//    rightConstraint.active = YES;
//    topConstraint.active = YES;
//    heightConstraint.active = YES;
//
    
    return navBar;

}

/**
 myNavBar 自定义titleView
 */
+(UINavigationItem * _Nullable)addMyNavBarWithCenterTitle:(id _Nullable)centerTitle  contentView:(UIView * _Nullable)view{
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight)];
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    //在这个集合Item中添加标题，按钮
    
    navBar.backgroundColor = QiCaiNavBackGroundColor;

    
//    //创建一个左边按钮
//    //最重要的一步，注意initWithCustomView方法。理论上左按钮可以是任意父类是UIView的控件.
//    UIBarButtonItem *leftButton;
//    //创建一个右边按钮
//    UIBarButtonItem *rightButton ;
    
    //判断 centerTitle  是否为NSString  类型
    if ([centerTitle isKindOfClass:[NSString class]] ) {
        //设置导航栏的内容
        [navItem setTitle:centerTitle];
    }else {
        navItem.titleView = centerTitle;
        
    }
    
//    //判断 right  是否为NSString  类型
//    if ([right isKindOfClass:[UIBarButtonItem class]] ) {
//        rightButton = right;
//    }else {
//        rightButton =  [[UIBarButtonItem alloc] initWithCustomView:right];
//    }
//    
//    //判断  left 是否为NSString  类型
//    if ([left isKindOfClass:[UIBarButtonItem class]] ) {
//        leftButton = left;
//    }else{
//        leftButton =  [[UIBarButtonItem alloc] initWithCustomView:left];
//    }
//    
//    if (iOS7) {
//        
//        leftButton.image = [leftButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
//    if (iOS7) {
//        
//        rightButton.image = [rightButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
//    
//    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [navBar pushNavigationItem:navItem animated:NO];
//
//    //把左右两个按钮添加到导航栏集合中去
//    [navItem setLeftBarButtonItem:leftButton];
//    [navItem setRightBarButtonItem:rightButton];
//    //    [navItem setTitleView:<#(UIView * _Nullable)#>]
    //调整按钮和标题的上下位置
    [navBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
//    [leftButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
//    [rightButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    
    //    //将标题栏中的内容全部添加到主视图当中
    //    [self.navigationController.navigationBar addSubview:navBar];
    //将标题栏中的内容全部添加到主视图当中
    [view addSubview:navBar];
    //    [[view superview] bringSubviewToFront:navBar];
    //    [view insertSubview:navBar atIndex:1];
    //    bringSubviewToFront
    return navItem;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];

    [self setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
    for (UIView *subView in self.subviews) {
        if ([subView isMemberOfClass:[UIButton class]]) {
//            CGRect rect = subView.frame;
//            rect.origin.y = 8.0f;
//            subView.frame = rect;
            subView.centerY = self.height / 2;
        }
        else if ([subView isMemberOfClass:[UIBarButtonItem class]]) {
            CGRect rect = subView.frame;
            rect.origin.y = 10.0f;
            subView.frame = rect;
        }
        else if ([subView isMemberOfClass:[MyButton class]]) {
            CGRect rect = subView.frame;
            rect.origin.y = 5.0f;
            rect.origin.x = 11.0f;
            subView.frame = rect;
            subView.centerY = self.height / 2;
        }else {
            CGRect barFrame = self.frame;
            barFrame.size.height = NavigationBarHeight; //新的高度

            self.frame = barFrame;

        }
    }
    
}
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"Logo.PNG"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

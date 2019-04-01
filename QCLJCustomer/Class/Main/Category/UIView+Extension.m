//
//  UIView+Extension.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/13.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UIView+Extension.h"
#import "Comment.h"

@implementation UIView (Extension)

/**
 myNavBar 左图中文
 */
+(void)addMyNavBarWithFrame:(CGRect)frame centerTitle:(NSString *)centerTitle addTarget:(nullable id)target action:(SEL)action contentView:(UIView *)view
{
    MyNavBar *navBar = [[MyNavBar alloc]init];
    navBar.backgroundColor = QiCaiNavBackGroundColor;
    navBar.frame = CGRectMake(0, 0, MYScreenW, QiCaiNavHeight);
    [navBar.leftBtn setBackgroundImage:[UIImage imageNamed:@"Main_public_left"] forState:UIControlStateNormal];
    navBar.titleLabel.text = centerTitle;
    [navBar.leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIButton *backBtn = [UIButton addBackBtnTarget:target action:action];
    [navBar addSubview:backBtn];
    [view addSubview:navBar];
}
/**
 myNavBar 左图中文右文
 */
+(void)addMyNavBarWithFrame:(CGRect)frame centerTitle:(NSString *)centerTitle addLeftTarget:(nullable id)LeftTarget leftAction:(SEL)leftAction rightTitle:(NSString *)rightTitle addrightTarget:(nullable id)rightTarget rightAction:(SEL)rightAction contentView:(UIView *)view
{
    MyNavBar *navBar = [[MyNavBar alloc]init];
    navBar.backgroundColor = QiCaiNavBackGroundColor;
    navBar.frame = CGRectMake(0, 0, MYScreenW, QiCaiNavHeight);
    [navBar.leftBtn setBackgroundImage:[UIImage imageNamed:@"Main_public_left"] forState:UIControlStateNormal];
    navBar.titleLabel.text = centerTitle;
    [navBar.leftBtn addTarget:LeftTarget action:leftAction forControlEvents:UIControlEventTouchUpInside];
    [navBar.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    [navBar.rightBtn addTarget:rightTarget action:rightAction forControlEvents:UIControlEventTouchUpInside];
    UIButton *backBtn = [UIButton addBackBtnTarget:LeftTarget action:leftAction];
    [navBar addSubview:backBtn];
//    [view addSubview:navBar];
    [view bringSubviewToFront:navBar];
}
/**
 myNavBar 左图中文右图  左边是返回
 */
+(void)addMyNavBarWithFrame:(CGRect)frame centerTitle:(NSString *)centerTitle addLeftTarget:(nullable id)LeftTarget leftAction:(SEL)leftAction rightImageName:(NSString *)rightImageName addrightTarget:(nullable id)rightTarget rightAction:(SEL)rightAction contentView:(UIView *)view
{
    MyNavBar *navBar = [[MyNavBar alloc]init];
    navBar.backgroundColor = QiCaiNavBackGroundColor;
    navBar.frame = CGRectMake(0, 0, MYScreenW, QiCaiNavHeight);
    [navBar.leftBtn setBackgroundImage:[UIImage imageNamed:@"Main_public_left"] forState:UIControlStateNormal];
    navBar.titleLabel.text = centerTitle;
    [navBar.leftBtn addTarget:LeftTarget action:leftAction forControlEvents:UIControlEventTouchUpInside];
    [navBar.rightBtn setImage:[UIImage imageNamed:rightImageName] forState:UIControlStateNormal];
    [navBar.rightBtn addTarget:rightTarget action:rightAction forControlEvents:UIControlEventTouchUpInside];
    UIButton *backBtn = [UIButton addBackBtnTarget:LeftTarget action:leftAction];
    [navBar addSubview:backBtn];
    [view addSubview:navBar];
}
/**
 myNavBar 左图中文右图 自定义图片
 */
+(void)addMyNavBarWithFrame:(CGRect)frame centerTitle:(NSString *)centerTitle addleftImage:(NSString *)leftImageName LeftTarget:(nullable id)LeftTarget leftAction:(SEL)leftAction rightImageName:(NSString *)rightImageName addrightTarget:(nullable id)rightTarget rightAction:(SEL)rightAction contentView:(UIView *)view
{
    MyNavBar *navBar = [[MyNavBar alloc]init];
    navBar.backgroundColor = QiCaiNavBackGroundColor;
    navBar.frame = CGRectMake(0, 0, MYScreenW, QiCaiNavHeight);
    [navBar.leftBtn setBackgroundImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
    navBar.titleLabel.text = centerTitle;
    [navBar.leftBtn addTarget:LeftTarget action:leftAction forControlEvents:UIControlEventTouchUpInside];
    [navBar.rightBtn setImage:[UIImage imageNamed:rightImageName] forState:UIControlStateNormal];
    [navBar.rightBtn addTarget:rightTarget action:rightAction forControlEvents:UIControlEventTouchUpInside];
    UIButton *backBtn = [UIButton addBackBtnTarget:LeftTarget action:leftAction];
    [navBar addSubview:backBtn];
    [view addSubview:navBar];
}

/**
 分割线 参考值 36  右边是有间距的
 */
+(UIView *)addHLineWithY:(CGFloat)lineY lineX:(CGFloat)lineX contentView:(UIView *)contentView
{
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = QiCaiBackGroundColor;
    lineView.frame = CGRectMake(lineX, lineY, MYScreenW - lineX - QiCaiMargin * 2, 1);
    [contentView addSubview:lineView];
    return lineView;
}
/**
 分割线
 */
+(UIView *)addHLineWithlineX:(CGFloat)lineX lineY:(CGFloat)lineY  contentView:(UIView *)contentView
{
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = QiCaiBackGroundColor;
    lineView.frame = CGRectMake(lineX, lineY, MYScreenW - lineX, 1);
    [contentView addSubview:lineView];
    return lineView;
}

- (void)setX:(CGFloat)x

{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}


- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}
@end

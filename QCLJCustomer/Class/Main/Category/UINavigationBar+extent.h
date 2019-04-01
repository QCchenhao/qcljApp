//
//  UINavigationItem+extent.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/11.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (extent)
/**
 myNavBar 左图中文
 */
+(UINavigationBar * _Nullable)addMyNavBarWithCenterTitle:(NSString * _Nullable)centerTitle addTarget:(nullable id)target action:(SEL _Nullable)action contentView:(UIView *_Nullable)view;
/**
 myNavBar 左图中文右文
 */
+(UINavigationBar *_Nullable)addMyNavBarWithCenterTitle:(NSString * _Nullable)centerTitle addLeftTarget:(nullable id)LeftTarget leftAction:(SEL _Nullable)leftAction rightTitle:(NSString *_Nullable)rightTitle addrightTarget:(nullable id)rightTarget rightAction:(SEL _Nullable)rightAction contentView:(UIView * _Nullable)view;
/**
 myNavBar 左图中文右图
 */
+(UINavigationBar * _Nullable)addMyNavBarWithCenterTitle:(NSString * _Nullable)centerTitle addLeftTarget:(nullable id)LeftTarget leftAction:(SEL _Nullable)leftAction rightImageName:(NSString * _Nullable)rightImageName rightImageNameLandscapeImage:(NSString * _Nullable)rightImageNameLandscapeImage addrightTarget:(nullable id)rightTarget rightAction:(SEL _Nullable)rightAction contentView:(UIView * _Nullable)view;
/**
 myNavBar 左自定义中文右自定义
 */
+(UINavigationBar * _Nullable)addMyNavBarWithCenterTitle:(NSString * _Nullable)centerTitle addLeft:(id _Nullable)left addRight:(id _Nullable)right  contentView:(UIView * _Nullable)view;
/**
 myNavBar 自定义titleView
 */
+(UINavigationItem * _Nullable)addMyNavBarWithCenterTitle:(id _Nullable)centerTitle  contentView:(UIView * _Nullable)view;

@end
